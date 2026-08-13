# CLAUDE.md — alepe

R package wrapping the open data API of the Legislative Assembly of
Pernambuco (<https://dadosabertos.alepe.pe.gov.br>). Target: CRAN, with
a pkgdown site. Part of André’s suite of Brazilian public-data packages
(`tcepe`, `comex`, `ibger`) sharing the same httr2/cli/tidyverse style.

## Working agreement

- Owner: André (<leite@castlab.org>), CASTLab/UFPE. Communicates in
  Brazilian Portuguese; **all package code, docs, vignettes, and commit
  messages are in English**.
- Broad delegation: implement without asking, **except** for (1)
  exported API surface changes (function names/signatures), (2) naming,
  and (3) architectural divergence from the current design. Pause and
  ask on those three.
- Every non-obvious choice gets an entry in `DECISIONS.md` (D1–D10 so
  far; continue the numbering).
- Small, descriptive commits — one logical change each. See `git log`
  for the established style.
- Visual changes (pkgdown theme, logo, README figures): show a preview
  before finalizing.

## Architecture (do not diverge without asking)

    R/req.R          alepe_req() -> alepe_perform() -> alepe_fetch_json()/csv()
    R/utils.R        clean_names(), records_to_tibble(schema), map_status()
    R/cache.R        alepe_cache_dir(), alepe_cache_clear()
    R/people.R       representatives, staff, positions, departments, remuneration
    R/money.R        contracts, procurements
    R/propositions.R bills, indications, requests (CSV path)
    R/aliases.R      Portuguese aliases (alepe_servidores(), ...) (D19)

- One exported function per endpoint, prefix `alepe_`, always returns a
  tibble. Each also has a Portuguese alias named after the endpoint
  ([`alepe_servidores()`](https://strategicprojects.github.io/alepe/reference/alepe_aliases.md),
  [`alepe_licitacoes()`](https://strategicprojects.github.io/alepe/reference/alepe_aliases.md));
  **any new endpoint needs its alias in `R/aliases.R` and a row in the
  table there** (D19).
- **Graceful failure contract** (CRAN internet policy): fetch layer
  returns `NULL` after a classed `cli_warn()` (`alepe_error_http`,
  `alepe_error_parse`); endpoint layer converts `NULL` into a zero-row
  tibble with the documented schema (propositions: zero-column tibble —
  see D5). Never [`stop()`](https://rdrr.io/r/base/stop.html) on network
  problems. `R CMD check` must never touch the network.
- Retry only 429/500/502/503/504, `max_tries = 3`, backoff `2^i` (D6).
- Cache via
  [`httr2::req_cache()`](https://httr2.r-lib.org/reference/req_cache.html)
  under `tools::R_user_dir("alepe", "cache")`, 6 h default,
  `refresh = TRUE` per call (D7).
- Options: `alepe.quiet`, `alepe.cache_dir`, `alepe.cache_max_age`,
  `alepe.max_tries`, `alepe.timeout`.
- Column names: official Portuguese fields normalized to snake_case,
  **never translated** (D2). Filter values: English first, Portuguese
  accepted (D3) — see `map_status()`.
- `clean_names()` uses explicit `chartr` transliteration:
  [`tolower()`](https://rdrr.io/r/base/chartr.html) and
  `iconv(//TRANSLIT)` are locale-dependent and break under the C locale
  on CRAN check machines. Do not “simplify” this back.
- Dependencies are deliberately minimal: httr2, cli, rlang, tibble,
  readr (D8). Do not add xml2 (D4). jsonlite arrives via httr2 but is
  declared in **Suggests** because the tests call it directly —
  `R CMD check` warns otherwise.

## API quirks (learned the hard way)

- Base: `https://dadosabertos.alepe.pe.gov.br/api/v1/<endpoint>/`;
  formats JSON/CSV, **except**
  `/proposicoes/{projetos,indicacoes, requerimentos}` which serve
  XML/CSV — we use CSV there.
- Propositions CSV is **XML inside a single CSV column**: one fragment
  per row in listing mode, one full document in detail mode. Parsed with
  regex in `R/propositions.R` (D13); free text is HTML-encoded
  (double-encoded for `indicacoes`) and goes through `strip_html()`.
- Propositions: detail mode needs `numero` + `ano` together (validated
  client-side, `alepe_error_input`); listing mode filters by `ano`
  and/or `legislatura`; no filter = current year (API default).
- `vinculo` values: `efetivo`, `comissionado`, `a-disposicao`.
- Field names come in **two conventions**: ALL_CAPS with underscores
  (`/servidores`) and camelCase (`nomeParlamentar`, `vigenciaInicio`);
  `clean_names()` handles both.
- Numbers come in **two encodings**: `"1.234,56"` and float-formatted
  strings (`"119267.04"`, `"2026.00"`). `parse_br_number()` decides per
  value — never swap it for a fixed-locale
  [`readr::parse_number()`](https://readr.tidyverse.org/reference/parse_number.html)
  (D12). Dates arrive either as `dd/mm/yyyy` strings or as serialized
  DateTime objects (`{"date": "...", "timezone": ...}`), unwrapped in
  `records_to_tibble()`.
- `/proposicoes` listing CSVs end with a blank row; the parser drops
  rows without a `docid`.
- `/lotacoes` has a fixed reference period baked in by the API and
  excludes retired staff.
- `/licitacoes` is flaky: it alternates between fast 200s and a
  server-side 30 s timeout returning HTTP 500. That is exactly the
  retry-then-graceful-failure path (500 is in the transient list), so an
  outage costs the user ~90 s and an empty tibble, not an error. Don’t
  “fix” it by dropping 500 from the retry list.
- The site’s robots.txt blocks generic crawlers; the package’s
  descriptive user agent is set in `alepe_req()` — keep it.
- **The API blocks GitHub-hosted runners entirely** (`http=000`, zero
  bytes, curl 28 after 90 s, probed 2026-08-13 from Azure eastus).
  Anything built in Actions sees an empty API, so the pkgdown site is
  published locally with `deploy_to_branch()` and the workflow is
  manual-only (D20). CI green therefore says nothing about live-data
  behaviour.

## Commands

``` bash
Rscript -e 'devtools::document()'
Rscript -e 'devtools::test()'
Rscript -e 'devtools::check()'                     # must be 0/0/0
NOT_CRAN=true Rscript -e 'pkgdown::build_site()'   # vignettes hit network

# Publish the site — from a machine that can reach the API, never CI (D20)
NOT_CRAN=true Rscript -e 'pkgdown::deploy_to_branch(new_process = FALSE)'
```

## State and pending work (in order)

Done: all 10 endpoint wrappers, core layer, `document()`, test suite
against **real** payload fixtures, 3 vignettes, pkgdown config, CI
workflows, NEWS, cran-comments, MIT license, DECISIONS.md (D1–D14).
Schemas verified against the live API on 2026-08-12 and corrected
(D12–D14).
[`devtools::check()`](https://devtools.r-lib.org/reference/check.html)
clean: 0 errors, 0 warnings, 0 notes. Repo lives at
`github.com/StrategicProjects/alepe` (public), site at
`strategicprojects.github.io/alepe`. Authors match `transferegovr`.

CLAUDE.md, DECISIONS.md and `.claude/` are **gitignored** — local notes
only, also stripped from the published history.

Also done: SVG hex logo and the two SVG diagrams (D17), tidytemplate
pkgdown site (D18), rhub (4/5 platforms green) and win-builder.

1.  Submit to CRAN; after acceptance, tag v0.1.0.
2.  Optional: `/licitacoes` currently publishes `valorEstimado`,
    `vencedor` and `valorAdjudicado` as null for every process, and
    `/contratos` publishes `numeroContrato` mirroring `cpfCnpj` — worth
    reporting to ALEPE and re-checking before release.

### Known non-issues in pre-submission checks

- **rhub `nosuggests` fails**, and that is the harness, not us: the
  container installs no Suggests at all, so vignette re-building dies on
  `there is no package called 'rmarkdown'` — the engine behind
  `output: rmarkdown::html_vignette`. Everything else in that run
  (install, examples, tests) is OK, and the same check passes locally
  under `_R_CHECK_DEPENDS_ONLY_=true`.
- **win-builder reports 1 NOTE**: `New submission` plus spell-check
  false positives (Pernambuco, backoff, tibbles). Expected.
- The README CRAN badge 404s until the package is accepted; flagged in
  `cran-comments.md` for the reviewer.

## Testing conventions

- `tests/testthat/setup.R` forces quiet mode, temp cache, 1 retry.
- Fixture tests mock `alepe_fetch_json` via `local_mocked_bindings()`;
  keep that pattern until httptest2 fixtures land, then migrate to
  `with_mock_dir()`.
- Always keep the graceful-failure contract tests (`test-graceful.R`)
  green — they encode the CRAN policy compliance.

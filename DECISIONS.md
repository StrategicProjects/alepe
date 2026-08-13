# Design decisions — alepe

Record of non-obvious choices, in the order they were made.

## D1. Package name: `alepe`

Short, lowercase, matches the institution’s acronym, consistent with the
`tcepe` sibling package. No CRAN conflict at the time of writing.
Alternatives considered: `alepepe`, `alepedata`.

## D2. Column names: normalized, not translated

API fields (`NOME_LOTACAO`, `CARGO_NIVEL`) are lowercased to snake_case
but **kept in Portuguese**. Rationale: traceability to the official
source and to the Assembly’s own documentation; the pattern followed by
most Brazilian public-data packages on CRAN (`geobr`, `microdatasus`).
Function names, arguments, and docs are in English.

## D3. Filter vocabulary: English first, Portuguese accepted

`status = "permanent" | "commissioned" | "seconded"` maps internally to
`vinculo=efetivo|comissionado|a-disposicao`. The original API terms are
also accepted via an extended `arg_match()`. Rationale: an
English-language package should not force users to guess Portuguese API
constants, but Brazilian users copy-pasting from the official docs
should not be punished either.

## D4. Propositions: CSV, not XML

The propositions endpoints serve XML or CSV (unlike the rest of the API,
which serves JSON or CSV). We request CSV and parse with readr, avoiding
an xml2 dependency and a second parsing code path. Trade-off: if the
API’s detail mode ever nests structures only expressible in XML, this
needs revisiting.

## D5. Graceful failure returns typed empty tibbles, not NULL

CRAN policy requires internet resources to fail gracefully with an
informative message. Endpoint functions warn (with classes
`alepe_error_http` / `alepe_error_parse`) and return a **zero-row tibble
with the documented schema**, not `NULL`. Rationale: downstream dplyr
pipelines survive; the schema contract holds even offline. The internal
fetch layer does return `NULL`, which the endpoint layer converts.

Exception: propositions return
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
(zero columns) on failure, because their schema is defined by the API
response, not by the package.

## D6. Retry/backoff policy

`req_retry(max_tries = 3, backoff = 2^i)` on 429/500/502/503/504 only.
4xx client errors are not retried (they will not fix themselves).
Configurable via `options(alepe.max_tries = )`.

## D7. Cache

[`httr2::req_cache()`](https://httr2.r-lib.org/reference/req_cache.html)
under `tools::R_user_dir("alepe", "cache")` (CRAN-compliant location), 6
h default expiry, per-call bypass with `refresh = TRUE`, global controls
via options,
[`alepe_cache_clear()`](https://strategicprojects.github.io/alepe/reference/alepe_cache_dir.md)
exported. Rationale for 6 h: the underlying datasets update at most
daily; 6 h balances freshness and API load.

## D8. readr as a hard dependency

Used for CSV parsing (propositions) and locale-aware number parsing
(`1.234,56` → `1234.56`). Considered
[`utils::read.csv`](https://rdrr.io/r/utils/read.table.html) +
hand-rolled parsing to save a dependency; rejected — readr is ubiquitous
in the target audience’s stack and its locale handling removes a class
of bugs.

## D9. Verbosity model

Messages via cli, on by default only in interactive sessions;
`options(alepe.quiet = TRUE/FALSE)` overrides. No messages ever affect
return values.

## D10. Tests offline by design

Unit tests mock the fetch layer and use JSON fixtures reconstructed from
the official documentation examples. Real-traffic fixtures should be
recorded once with httptest2 (instructions in
`tests/testthat/test-endpoints.R`) before the first CRAN submission.
`R CMD check` never touches the network.

## D11. Fixtures are verbatim samples of real payloads (2026-08-12)

The guessed fixtures were replaced with the first records of each real
endpoint response, captured with curl on 2026-08-12. The
`local_mocked_bindings()` pattern was kept instead of migrating to
[`httptest2::with_mock_dir()`](https://enpiar.com/httptest2/reference/with_mock_dir.html):
mocking at the fetch layer exercises the same parsing code with less
machinery, and the graceful-failure tests already cover the layer below.
httptest2 stays in Suggests for future recording sessions. Refresh
instructions live in the header of `tests/testthat/test-endpoints.R`.

## D12. Number parsing is heuristic, not locale-based

Observed payloads mix two numeric encodings: Brazilian comma-decimal
strings (`"1.234,56"`, propositions ementas) and plain float-formatted
strings (`"119267.04"`, `"2026.00"` — contracts, procurements,
remuneration). A fixed `readr` locale corrupts one or the other (BRL
locale reads `"119267.04"` as 11 926 704). `parse_br_number()` decides
per value: a comma is always the decimal mark; without a comma, dots are
group marks only when they form pure 3-digit groups. Integer years and
process numbers arrive float-formatted (`"2026.00"`) and are rounded to
integer.

## D13. Propositions XML-in-CSV parsed with regex, still no xml2

The propositions CSV is a single column carrying one XML fragment per
row (listing) or one XML document (detail). Rather than adding xml2 (D4)
or returning raw XML strings, the fragments are parsed with regular
expressions — they are flat, machine-generated, and attribute-quoted, so
the usual “don’t parse XML with regex” hazards do not apply. Listing
returns docid/numero/ano/legislatura/tipo/subtipo/
ementa/data_publicacao plus `autores` (collapsed `;`-separated author
names); detail returns the scalar elements (materia, justificativa,
regime, resultado, etc.). HTML markup and entities in free-text fields
are stripped/decoded (`strip_html()`), including the double-encoded
ementas of indicacoes. `materiaHtml`/`justificativaHtml` and the
`historico` event log are deliberately not returned.

## D14. Schemas corrected against observed payloads (2026-08-12)

Documentation-guessed schemas were wrong in places; the observed truth:
`/parlamentares` has only `nomeParlamentar` + `partido` (no email);
`/servidores` has no `SEQ`/`SITUACAO` but has `CARGO_EFETIVO` and
`DATA_ADMISSAO` (a serialized PHP DateTime object — handled in
`records_to_tibble()`); `/remuneracao` includes `tipoCargo`,
`mesCompetencia`, `anoCompetencia`; `/contratos` uses `contratada`,
`numeroContrato`, `vigenciaInicio/Fim` and links to its procurement via
`numeroLicitacao`/`anoLicitacao` (note: the API currently publishes
`numeroContrato` mirroring `cpfCnpj`); `/licitacoes` uses `status`,
`valorEstimado`, `valorAdjudicado`, `vencedor` (the latter three null
for undecided processes). camelCase field names are split to snake_case
by `clean_names()`. Identifier strings (`cpfCnpj`) are kept exactly as
published, float-formatting artifacts included.

## D15. Default timeout raised from 30 s to 60 s (2026-08-13)

`/licitacoes` regularly answers in ~28 s and, when the server is under
load, spends 30 s and then returns HTTP 500. With a 30 s client timeout
the endpoint failed intermittently for no reason other than the margin
being too thin. 60 s keeps well clear of it while still bounding a hung
request. Retry policy is unchanged: 500 stays in the transient list
(D6), so a genuine server error still costs three attempts before the
graceful-failure path.

## D16. Vignette charts are guarded against an empty API response

The first published site showed *blank* charts: the pkgdown build ran
during an API outage, the endpoints returned zero-row tibbles exactly as
designed, and ggplot2 dutifully drew empty panels. A blank chart reads
as a broken package, which is worse than no chart. Every chart chunk now
carries `eval = have_rows(x)`, and a companion chunk emits a short note
when the data is missing. The guard lives in the vignettes, not in the
package: the graceful-failure contract itself is unchanged.

## D17. Visual assets are SVG

`man/figures/logo.svg`, `request-flow.svg` and `architecture.svg` are
hand-written SVG rather than generated bitmaps: they stay sharp at any
size, cost a few KB, and can be diffed and edited in a text editor.
Colours are explicit (no `currentColor`) and every diagram paints its
own light background, so it reads the same in the site’s light and dark
modes. Both diagrams carry `<title>`/`<desc>` and the README `<img>`
tags carry long `alt` text describing the flow in words.

## D18. pkgdown uses tidytemplate

The site follows the tidyverse look via
`template: package: tidytemplate`. tidytemplate is not on CRAN, so it is
declared in `Config/Needs/website` (as `tidyverse/tidytemplate`) where
the r-lib setup action can install it from GitHub; it is a website-only
dependency and never affects `R CMD check` or installation.

## D19. Portuguese aliases for every endpoint function

The exported surface is English (D2/D3 keep column names Portuguese and
filter values bilingual), but the audience is Brazilian and the API’s
own vocabulary is Portuguese. Each endpoint function now has an alias
named after the endpoint it wraps —
[`alepe_servidores()`](https://strategicprojects.github.io/alepe/reference/alepe_aliases.md)
for
[`alepe_staff()`](https://strategicprojects.github.io/alepe/reference/alepe_staff.md),
[`alepe_licitacoes()`](https://strategicprojects.github.io/alepe/reference/alepe_aliases.md)
for
[`alepe_procurements()`](https://strategicprojects.github.io/alepe/reference/alepe_procurements.md)
— so a pipeline can stay in one language end to end.

They are real wrapper functions, not `f <- g` assignments: this gives
correct `\usage` sections, keeps argument documentation attached, and
makes error messages point at the function the user actually called. The
propositions aliases also translate the argument names
(`numero`/`ano`/`legislatura`), which is why they spell out their
signature instead of forwarding `...`.

Names carry no accents: accented identifiers are legal in R but awkward
to type and fragile across locales — the same reasoning that drives the
`chartr` transliteration in `clean_names()`.

## D20. The site is published from a machine that can reach the API

The ALEPE API refuses connections from GitHub-hosted runners. A probe
job on `ubuntu-latest` (Azure eastus) got `http=000`, zero bytes and
curl exit 28 on `/contratos`, `/servidores` and `/licitacoes` after 90 s
each, while the same requests answer in under a second from a laptop in
Brazil. Presumably a WAF or geo rule against datacenter ranges —
consistent with the robots.txt that blocks generic crawlers.

Consequences, in order of importance:

1.  Vignettes built on GitHub Actions contain no data. That is what
    produced the blank charts on the first published site, and what the
    D16 guards now turn into an honest note.
2.  So `pkgdown.yaml` is `workflow_dispatch` only, and the site is
    published with
    [`pkgdown::deploy_to_branch()`](https://pkgdown.r-lib.org/reference/deploy_to_branch.html)
    from a machine that can reach the API. Otherwise the next push would
    silently replace a good site with a data-less one.
3.  `R CMD check` on CI is unaffected — it passes either way, because
    the graceful-failure contract turns the outage into zero-row tibbles
    rather than errors. Worth remembering that CI therefore proves
    nothing about live-data behaviour; that is what the local check and
    the fixtures are for.

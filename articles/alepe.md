# Getting started with alepe

The `alepe` package provides a tidy interface to the open data API of
the Legislative Assembly of the State of Pernambuco, Brazil
([ALEPE](https://dadosabertos.alepe.pe.gov.br)). Every function returns
a tibble with snake_case column names and parsed types, ready for the
tidyverse.

[`library`](https://rdrr.io/r/base/library.html)`(`[`alepe`](https://github.com/StrategicProjects/alepe)`)`

## Available data

| Function | Endpoint | Contents |
|----|----|----|
| [`alepe_representatives()`](https://strategicprojects.github.io/alepe/reference/alepe_representatives.md) | `/parlamentares` | Current state representatives |
| [`alepe_staff()`](https://strategicprojects.github.io/alepe/reference/alepe_staff.md) | `/servidores` | Staff roster |
| [`alepe_positions()`](https://strategicprojects.github.io/alepe/reference/alepe_positions.md) | `/cargos` | Staff counts per position |
| [`alepe_departments()`](https://strategicprojects.github.io/alepe/reference/alepe_departments.md) | `/lotacoes` | Staff counts per department |
| [`alepe_remuneration()`](https://strategicprojects.github.io/alepe/reference/alepe_remuneration.md) | `/remuneracao` | Remuneration per position |
| [`alepe_contracts()`](https://strategicprojects.github.io/alepe/reference/alepe_contracts.md) | `/contratos` | Administrative contracts |
| [`alepe_procurements()`](https://strategicprojects.github.io/alepe/reference/alepe_procurements.md) | `/licitacoes` | Procurement processes |
| [`alepe_bills()`](https://strategicprojects.github.io/alepe/reference/alepe_bills.md) | `/proposicoes/projetos` | Bills |
| [`alepe_indications()`](https://strategicprojects.github.io/alepe/reference/alepe_bills.md) | `/proposicoes/indicacoes` | Indications |
| [`alepe_requests()`](https://strategicprojects.github.io/alepe/reference/alepe_bills.md) | `/proposicoes/requerimentos` | Requests |

## A first query

`reps`` ``<-`` `[`alepe_representatives`](https://strategicprojects.github.io/alepe/reference/alepe_representatives.md)`(``)`` ``reps`` ``#> ``# A tibble: 49 × 2`` ``#> nome_parlamentar partido`` ``#> ``<chr>`` ``<chr>`` `` ``#> `` 1`` Abimael Santos PL `` ``#> `` 2`` Adalto Santos PP `` ``#> `` 3`` Aglailson Victor PSD `` ``#> `` 4`` Álvaro Porto MDB `` ``#> `` 5`` Antonio Coelho União `` ``#> `` 6`` Antônio Moraes PSD `` ``#> `` 7`` Cayo Albino PSB `` ``#> `` 8`` Claudiano Martins Filho PP `` ``#> `` 9`` Coronel Alberto Feitosa PL `` ``#> ``10`` Dani Portela PT `` ``#> ``# ℹ 39 more rows`

Filters use an English vocabulary, but the original Portuguese API terms
are accepted too — these are equivalent:

`permanent`` ``<-`` `[`alepe_staff`](https://strategicprojects.github.io/alepe/reference/alepe_staff.md)`(``status ``=`` ``"permanent"``)`` ``permanent_pt`` ``<-`` `[`alepe_staff`](https://strategicprojects.github.io/alepe/reference/alepe_staff.md)`(``status ``=`` ``"efetivo"``)`` `[`identical`](https://rdrr.io/r/base/identical.html)`(``permanent``, ``permanent_pt``)`` ``#> [1] TRUE`

## Em português

The same goes for the function names themselves: every endpoint function
has an alias named after the endpoint it wraps, so a pipeline can stay
in Portuguese from end to end.

[`identical`](https://rdrr.io/r/base/identical.html)`(`[`alepe_servidores`](https://strategicprojects.github.io/alepe/reference/alepe_aliases.md)`(``status ``=`` ``"efetivo"``)``, ``permanent``)`` ``#> [1] TRUE`

[`alepe_parlamentares()`](https://strategicprojects.github.io/alepe/reference/alepe_aliases.md),
[`alepe_cargos()`](https://strategicprojects.github.io/alepe/reference/alepe_aliases.md),
[`alepe_lotacoes()`](https://strategicprojects.github.io/alepe/reference/alepe_aliases.md),
[`alepe_remuneracao()`](https://strategicprojects.github.io/alepe/reference/alepe_aliases.md),
[`alepe_contratos()`](https://strategicprojects.github.io/alepe/reference/alepe_aliases.md),
[`alepe_licitacoes()`](https://strategicprojects.github.io/alepe/reference/alepe_aliases.md),
[`alepe_projetos()`](https://strategicprojects.github.io/alepe/reference/alepe_aliases.md),
[`alepe_indicacoes()`](https://strategicprojects.github.io/alepe/reference/alepe_aliases.md),
[`alepe_requerimentos()`](https://strategicprojects.github.io/alepe/reference/alepe_aliases.md)
and
[`alepe_limpar_cache()`](https://strategicprojects.github.io/alepe/reference/alepe_aliases.md)
complete the set. The propositions aliases take Portuguese argument
names as well — `alepe_projetos(ano = 2024)`. See
[`?alepe_aliases`](https://strategicprojects.github.io/alepe/reference/alepe_aliases.md).

## Caching

Responses are cached under `tools::R_user_dir("alepe", "cache")` for six
hours by default, so repeated calls in an analysis session do not hit
the API again. Control it with:

`# Change expiry (seconds)`` `[`options`](https://rdrr.io/r/base/options.html)`(``alepe.cache_max_age ``=`` ``24`` ``*`` ``3600``)`` `` ``# Force a fresh download for one call`` `[`alepe_staff`](https://strategicprojects.github.io/alepe/reference/alepe_staff.md)`(``refresh ``=`` ``TRUE``)`` `` ``# Wipe the cache`` `[`alepe_cache_clear`](https://strategicprojects.github.io/alepe/reference/alepe_cache_dir.md)`(``)`

## Graceful failures

Following CRAN policy for internet resources, `alepe` never errors on
network problems. Requests are retried up to three times with
exponential backoff; if the API remains unreachable, the function warns
and returns a zero-row tibble with the documented columns, so pipelines
downstream keep working:

`out`` ``<-`` `[`alepe_contracts`](https://strategicprojects.github.io/alepe/reference/alepe_contracts.md)`(``)`` ``#> Warning: The ALEPE open data API could not be reached.`` `[`nrow`](https://rdrr.io/r/base/nrow.html)`(``out``)`` ``#> [1] 0`

Warnings carry classes (`alepe_error_http`, `alepe_error_parse`) for
programmatic handling with
[`withCallingHandlers()`](https://rdrr.io/r/base/conditions.html) or
[`tryCatch()`](https://rdrr.io/r/base/conditions.html).

## Verbosity

Progress messages (powered by [cli](https://cli.r-lib.org)) appear in
interactive sessions. Silence or force them with:

[`options`](https://rdrr.io/r/base/options.html)`(``alepe.quiet ``=`` ``TRUE``)`

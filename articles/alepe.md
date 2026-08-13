# Getting started with alepe

The `alepe` package provides a tidy interface to the open data API of
the Legislative Assembly of the State of Pernambuco, Brazil
([ALEPE](https://dadosabertos.alepe.pe.gov.br)). Every function returns
a tibble with snake_case column names and parsed types, ready for the
tidyverse.

``` r

library(alepe)
```

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

``` r

reps <- alepe_representatives()
#> Warning in alepe_representatives(): ! The ALEPE open data API could not be reached.
#> ℹ Returning `NULL`. Original error: Failed to perform HTTP request. Caused by
#>   error in `curl::curl_fetch_memory()`: ! Timeout was reached
#>   [dadosabertos.alepe.pe.gov.br]: Connection timed out after 30001 milliseconds
#> ℹ The service may be temporarily down; try again later.
reps
#> # A tibble: 0 × 2
#> # ℹ 2 variables: nome_parlamentar <chr>, partido <chr>
```

Filters use an English vocabulary, but the original Portuguese API terms
are accepted too — these are equivalent:

``` r

permanent <- alepe_staff(status = "permanent")
#> Warning in alepe_staff(status = "permanent"): ! The ALEPE open data API could not be reached.
#> ℹ Returning `NULL`. Original error: Failed to perform HTTP request. Caused by
#>   error in `curl::curl_fetch_memory()`: ! Timeout was reached
#>   [dadosabertos.alepe.pe.gov.br]: Connection timed out after 30002 milliseconds
#> ℹ The service may be temporarily down; try again later.
permanent_pt <- alepe_staff(status = "efetivo")
#> Warning in alepe_staff(status = "efetivo"): ! The ALEPE open data API could not be reached.
#> ℹ Returning `NULL`. Original error: Failed to perform HTTP request. Caused by
#>   error in `curl::curl_fetch_memory()`: ! Timeout was reached
#>   [dadosabertos.alepe.pe.gov.br]: Connection timed out after 30002 milliseconds
#> ℹ The service may be temporarily down; try again later.
identical(permanent, permanent_pt)
#> [1] TRUE
```

## Caching

Responses are cached under `tools::R_user_dir("alepe", "cache")` for six
hours by default, so repeated calls in an analysis session do not hit
the API again. Control it with:

``` r

# Change expiry (seconds)
options(alepe.cache_max_age = 24 * 3600)

# Force a fresh download for one call
alepe_staff(refresh = TRUE)

# Wipe the cache
alepe_cache_clear()
```

## Graceful failures

Following CRAN policy for internet resources, `alepe` never errors on
network problems. Requests are retried up to three times with
exponential backoff; if the API remains unreachable, the function warns
and returns a zero-row tibble with the documented columns, so pipelines
downstream keep working:

``` r

out <- alepe_contracts()
#> Warning: The ALEPE open data API could not be reached.
nrow(out)
#> [1] 0
```

Warnings carry classes (`alepe_error_http`, `alepe_error_parse`) for
programmatic handling with
[`withCallingHandlers()`](https://rdrr.io/r/base/conditions.html) or
[`tryCatch()`](https://rdrr.io/r/base/conditions.html).

## Verbosity

Progress messages (powered by [cli](https://cli.r-lib.org)) appear in
interactive sessions. Silence or force them with:

``` r

options(alepe.quiet = TRUE)
```

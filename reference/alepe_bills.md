# Query legislative propositions

Retrieves legislative propositions from the Assembly: bills
(`alepe_bills()`), indications (`alepe_indications()`), and requests
(`alepe_requests()`). Two query modes are supported by the API:

## Usage

``` r
alepe_bills(number = NULL, year = NULL, legislature = NULL, refresh = FALSE)

alepe_indications(
  number = NULL,
  year = NULL,
  legislature = NULL,
  refresh = FALSE
)

alepe_requests(number = NULL, year = NULL, legislature = NULL, refresh = FALSE)
```

## Arguments

- number:

  Proposition number, for the detail mode. Requires `year`.

- year:

  Filter by year (listing mode) or select the proposition (detail mode).

- legislature:

  Filter by legislature number (listing mode).

- refresh:

  If `TRUE`, bypass the local cache.

## Value

A tibble. In listing mode, one row per proposition with `docid`,
`numero`, `ano`, `legislatura`, `tipo`, `subtipo`, `ementa`,
`data_publicacao` (`Date`), and `autores` (author names, `;`-separated).
In detail mode, a single row with `numero`, `ano`, `legislatura`,
`tipo`, `autores`, `ementa`, `materia`, `justificativa`,
`regime_tramitacao`, `impacto_orcamentario`, `resultado_final`,
`data_publicacao` (`Date`), `numero_dpl`, and `lotacao_atual`. On
network failure, a zero-column tibble (with a warning).

## Details

- **Detail**: pass `number` and `year` to fetch the full record of a
  single proposition.

- **Listing**: pass `year` and/or `legislature` to fetch summaries of
  multiple propositions. When no filter is given, the API defaults to
  the current year.

These endpoints serve structured data as XML embedded in CSV; the
package parses the XML fields into regular columns, with names
normalized to snake_case and HTML markup stripped from free-text fields.

## Examples

``` r
if (FALSE) { # interactive()
# All bills of the current year
alepe_bills()

# One specific bill
alepe_bills(number = 100, year = 2024)
}
```

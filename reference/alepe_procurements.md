# List procurement processes

Retrieves the Assembly's procurement (bidding) processes, including
process number and year, modality, object, estimated and awarded values,
winner, and status.

## Usage

``` r
alepe_procurements(refresh = FALSE)
```

## Arguments

- refresh:

  If `TRUE`, bypass the local cache.

## Value

A tibble with one row per procurement process: `numero_processo`, `ano`,
`numero_modalidade`, `modalidade`, `objeto`, `valor_estimado` (numeric,
BRL), `status`, `vencedor`, and `valor_adjudicado` (numeric, BRL). Value
and winner fields are `NA` when the process has not been decided. Zero
rows (with a warning) on network failure.

## Examples

``` r
if (FALSE) { # interactive()
alepe_procurements()
}
```

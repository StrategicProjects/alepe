# List remuneration by position

Retrieves position remuneration values published by the Assembly for the
current reference month.

## Usage

``` r
alepe_remuneration(refresh = FALSE)
```

## Arguments

- refresh:

  If `TRUE`, bypass the local cache.

## Value

A tibble with `cargo`, `remuneracao` (numeric, BRL), `tipo_cargo`,
`mes_competencia`, and `ano_competencia`. Zero rows (with a warning) on
network failure.

## Examples

``` r
if (FALSE) { # interactive()
alepe_remuneration()
}
```

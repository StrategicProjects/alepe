# List current state representatives

Retrieves the members of the current legislature of the Legislative
Assembly of Pernambuco, with name and party.

## Usage

``` r
alepe_representatives(refresh = FALSE)
```

## Arguments

- refresh:

  If `TRUE`, bypass the local cache.

## Value

A tibble with one row per representative: `nome_parlamentar` and
`partido`. On network failure a warning is issued and a zero-row tibble
with the same columns is returned.

## Examples

``` r
if (FALSE) { # interactive()
alepe_representatives()
}
```

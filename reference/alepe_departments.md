# Count staff by department

Retrieves the number of active staff members grouped by department
(`lotacao`) and employment status. The reference period is fixed by the
API and excludes retired staff.

## Usage

``` r
alepe_departments(refresh = FALSE)
```

## Arguments

- refresh:

  If `TRUE`, bypass the local cache.

## Value

A tibble with `total`, `nome_lotacao`, and `vinculo`. Zero rows (with a
warning) on network failure.

## Examples

``` r
if (FALSE) { # interactive()
alepe_departments()
}
```

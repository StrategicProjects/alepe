# Count staff by position

Retrieves the number of staff members per position/level, optionally
filtered by employment status.

## Usage

``` r
alepe_positions(status = NULL, refresh = FALSE)
```

## Arguments

- status:

  Employment status filter. One of `"permanent"`, `"commissioned"`, or
  `"seconded"` (the original API terms `"efetivo"`, `"comissionado"`,
  and `"a-disposicao"` are also accepted), or `NULL` (default) for all.

- refresh:

  If `TRUE`, bypass the local cache.

## Value

A tibble with `total` and `cargo_nivel`. Zero rows (with a warning) on
network failure.

## Examples

``` r
if (FALSE) { # interactive()
alepe_positions(status = "commissioned")
}
```

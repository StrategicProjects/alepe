# List ALEPE staff

Retrieves the Assembly's staff roster, optionally filtered by employment
status.

## Usage

``` r
alepe_staff(status = NULL, refresh = FALSE)
```

## Arguments

- status:

  Employment status filter. One of `"permanent"`, `"commissioned"`, or
  `"seconded"` (the original API terms `"efetivo"`, `"comissionado"`,
  and `"a-disposicao"` are also accepted), or `NULL` (default) for all.

- refresh:

  If `TRUE`, bypass the local cache.

## Value

A tibble with one row per staff member: `nome`, `codigo_lotacao`,
`nome_lotacao`, `cargo_efetivo`, `cargo_nivel`, `vinculo`, and
`data_admissao` (`Date`). Zero rows (with a warning) on network failure.

## Examples

``` r
if (FALSE) { # interactive()
alepe_staff(status = "permanent")
}
```

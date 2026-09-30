# List ALEPE staff

Retrieves the Assembly's staff roster, optionally filtered by employment
status.

## Usage

``` r
alepe_staff(status = NULL, refresh = FALSE)
```

## Arguments

- status:

  Employment status filter. One of `"permanent"`, `"commissioned"`,
  `"seconded"` (staff from other bodies placed at the Assembly's
  disposal), or `"lent"` (the Assembly's own permanent staff lent to
  other bodies, a subset of `"permanent"`); the original API terms
  `"efetivo"`, `"comissionado"`, `"a-disposicao"`, and
  `"efetivo-cedido"` are also accepted. `NULL` (default) for all. Lent
  staff are published with `vinculo` `"Efetivo"`, so this filter is the
  only way to tell them apart.

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

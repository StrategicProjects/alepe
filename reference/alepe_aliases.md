# Portuguese aliases

Every endpoint function has an alias named after the API endpoint it
wraps, for analysts who would rather keep their whole pipeline in
Portuguese. The aliases are ordinary functions with the same arguments,
the same defaults and the same return value as their English
counterparts — only the name differs.

## Usage

``` r
alepe_parlamentares(refresh = FALSE)

alepe_servidores(status = NULL, refresh = FALSE)

alepe_cargos(status = NULL, refresh = FALSE)

alepe_lotacoes(refresh = FALSE)

alepe_remuneracao(refresh = FALSE)

alepe_contratos(refresh = FALSE)

alepe_licitacoes(refresh = FALSE)

alepe_projetos(numero = NULL, ano = NULL, legislatura = NULL, refresh = FALSE)

alepe_indicacoes(
  numero = NULL,
  ano = NULL,
  legislatura = NULL,
  refresh = FALSE
)

alepe_requerimentos(
  numero = NULL,
  ano = NULL,
  legislatura = NULL,
  refresh = FALSE
)

alepe_limpar_cache()
```

## Arguments

- refresh:

  If `TRUE`, bypass the local cache.

- status:

  Employment status filter. One of `"permanent"`, `"commissioned"`, or
  `"seconded"` (the original API terms `"efetivo"`, `"comissionado"`,
  and `"a-disposicao"` are also accepted), or `NULL` (default) for all.

- numero:

  Portuguese spelling of `number`.

- ano:

  Portuguese spelling of `year`.

- legislatura:

  Portuguese spelling of `legislature`.

## Value

The same tibble the corresponding English function returns.

## Details

|  |  |
|----|----|
| Portuguese | English |
| `alepe_parlamentares()` | [`alepe_representatives()`](https://strategicprojects.github.io/alepe/reference/alepe_representatives.md) |
| `alepe_servidores()` | [`alepe_staff()`](https://strategicprojects.github.io/alepe/reference/alepe_staff.md) |
| `alepe_cargos()` | [`alepe_positions()`](https://strategicprojects.github.io/alepe/reference/alepe_positions.md) |
| `alepe_lotacoes()` | [`alepe_departments()`](https://strategicprojects.github.io/alepe/reference/alepe_departments.md) |
| `alepe_remuneracao()` | [`alepe_remuneration()`](https://strategicprojects.github.io/alepe/reference/alepe_remuneration.md) |
| `alepe_contratos()` | [`alepe_contracts()`](https://strategicprojects.github.io/alepe/reference/alepe_contracts.md) |
| `alepe_licitacoes()` | [`alepe_procurements()`](https://strategicprojects.github.io/alepe/reference/alepe_procurements.md) |
| `alepe_projetos()` | [`alepe_bills()`](https://strategicprojects.github.io/alepe/reference/alepe_bills.md) |
| `alepe_indicacoes()` | [`alepe_indications()`](https://strategicprojects.github.io/alepe/reference/alepe_bills.md) |
| `alepe_requerimentos()` | [`alepe_requests()`](https://strategicprojects.github.io/alepe/reference/alepe_bills.md) |
| `alepe_limpar_cache()` | [`alepe_cache_clear()`](https://strategicprojects.github.io/alepe/reference/alepe_cache_dir.md) |

Names are written without accents, since accented characters in R
identifiers are awkward to type and travel badly between locales.

Argument *values* follow the same both-ways rule: `status` accepts the
English vocabulary and the original API terms alike, so
`alepe_servidores(status = "efetivo")` and
`alepe_staff(status = "permanent")` are the same query.

## Examples

``` r
if (FALSE) { # interactive()
alepe_parlamentares()
alepe_servidores(status = "efetivo")
alepe_projetos(ano = 2024)
}
```

# List administrative contracts

Retrieves the Assembly's administrative contracts, including modality,
contractor name and tax id (CPF/CNPJ), object, value, originating
procurement process, and validity period.

## Usage

``` r
alepe_contracts(refresh = FALSE)
```

## Arguments

- refresh:

  If `TRUE`, bypass the local cache.

## Value

A tibble with one row per contract: `modalidade`, `numero_contrato`,
`ano`, `contratada`, `cpf_cnpj`, `objeto`, `valor` (numeric, BRL),
`numero_licitacao`, `ano_licitacao`, `vigencia_inicio`, and
`vigencia_fim` (`Date`). Identifier fields are kept as published by the
API. Zero rows (with a warning) on network failure.

## Examples

``` r
if (FALSE) { # interactive()
alepe_contracts()
}
```

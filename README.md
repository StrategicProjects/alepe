# alepe

<!-- badges: start -->
[![R-CMD-check](https://github.com/StrategicProjects/alepe/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/StrategicProjects/alepe/actions/workflows/R-CMD-check.yaml)
[![CRAN status](https://www.r-pkg.org/badges/version/alepe)](https://CRAN.R-project.org/package=alepe)
<!-- badges: end -->

Tidy access to the open data API of the Legislative Assembly of the
State of Pernambuco, Brazil ([ALEPE](https://dadosabertos.alepe.pe.gov.br)):
representatives, staff, positions, departments, remuneration, contracts,
procurement, and legislative propositions — as tibbles with clean names
and parsed types.

- Built on [httr2](https://httr2.r-lib.org): local **caching**,
  automatic **retries with exponential backoff**, descriptive user agent.
- **Graceful failures**: network problems warn and return typed
  zero-row tibbles — your pipeline keeps running.
- Friendly progress messages via [cli](https://cli.r-lib.org),
  silenceable with `options(alepe.quiet = TRUE)`.

## Installation

```r
# CRAN (once accepted)
install.packages("alepe")

# Development version
pak::pak("StrategicProjects/alepe")
```

## Quick start

```r
library(alepe)
library(dplyr)

# Current representatives
alepe_representatives()

# Permanent staff, largest departments
alepe_staff(status = "permanent") |>
  count(nome_lotacao, sort = TRUE)

# Contracts active today
alepe_contracts() |>
  filter(vigencia_inicio <= Sys.Date(), vigencia_fim >= Sys.Date())

# Bills of a given year
alepe_bills(year = 2024)
```

Filter values use an English vocabulary (`"permanent"`,
`"commissioned"`, `"seconded"`), but the original API terms
(`"efetivo"`, `"comissionado"`, `"a-disposicao"`) are accepted as well.
Column names keep the official Portuguese field names, normalized to
snake_case, so results stay traceable to the source.

## Related packages

Part of a family of packages for Brazilian public data sharing the same
httr2/cli design, developed at CASTLab/UFPE:
[transferegovr](https://github.com/StrategicProjects/transferegovr),
`tcepe`, `comex`, `ibger`.

## Code of Conduct

Please note that this project is released with a [Contributor Code of
Conduct](https://contributor-covenant.org/version/2/1/CODE_OF_CONDUCT.html).
By contributing you agree to abide by its terms.

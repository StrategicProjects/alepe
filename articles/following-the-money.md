# Following the money: contracts and procurement

Public procurement data is where open legislative data meets social
accountability. This vignette explores the Assembly’s contracts and
bidding processes.

[`library`](https://rdrr.io/r/base/library.html)`(`[`alepe`](https://github.com/StrategicProjects/alepe)`)`` `[`library`](https://rdrr.io/r/base/library.html)`(`[`dplyr`](https://dplyr.tidyverse.org)`)`` `[`library`](https://rdrr.io/r/base/library.html)`(`[`ggplot2`](https://ggplot2.tidyverse.org)`)`

## Contract values by modality

`contracts`` ``<-`` `[`alepe_contracts`](https://strategicprojects.github.io/alepe/reference/alepe_contracts.md)`(``)`` `` ``contracts`` ``|>`` `` `[`summarise`](https://dplyr.tidyverse.org/reference/summarise.html)`(`` `` n ``=`` `[`n`](https://dplyr.tidyverse.org/reference/context.html)`(``)``,`` `` total_brl ``=`` `[`sum`](https://rdrr.io/r/base/sum.html)`(``valor``, na.rm ``=`` ``TRUE``)``,`` `` .by ``=`` ``modalidade`` `` ``)`` ``|>`` `` `[`arrange`](https://dplyr.tidyverse.org/reference/arrange.html)`(`[`desc`](https://dplyr.tidyverse.org/reference/desc.html)`(``total_brl``)``)`` ``#> ``# A tibble: 10 × 3`` ``#> modalidade n total_brl`` ``#> ``<chr>`` ``<int>`` ``<dbl>`` ``#> `` 1`` Pregão Eletrônico 325 397``636``268.`` ``#> `` 2`` Pregão Presencial 86 107``029``186.`` ``#> `` 3`` Concorrência - Presencial 11 96``633``877.`` ``#> `` 4`` ``NA`` 46 59``623``440.`` ``#> `` 5`` Dispensa 67 57``009``695.`` ``#> `` 6`` Inexigibilidade 70 20``914``208.`` ``#> `` 7`` Convite 38 3``071``596.`` ``#> `` 8`` Concorrência - Eletrônica 1 1``865``008.`` ``#> `` 9`` Tomada de Preços 1 ``777``140 `` ``#> ``10`` Dispensa Eletrônica 1 ``9``980`

## Largest contractors

`contracts`` ``|>`` `` `[`summarise`](https://dplyr.tidyverse.org/reference/summarise.html)`(``total_brl ``=`` `[`sum`](https://rdrr.io/r/base/sum.html)`(``valor``, na.rm ``=`` ``TRUE``)``, .by ``=`` ``contratada``)`` ``|>`` `` `[`slice_max`](https://dplyr.tidyverse.org/reference/slice.html)`(``total_brl``, n ``=`` ``10``)`` ``|>`` `` `[`ggplot`](https://ggplot2.tidyverse.org/reference/ggplot.html)`(`[`aes`](https://ggplot2.tidyverse.org/reference/aes.html)`(``x ``=`` `[`reorder`](https://rdrr.io/r/stats/reorder.factor.html)`(``contratada``, ``total_brl``)``, y ``=`` ``total_brl`` ``/`` ``1e6``)``)`` ``+`` `` `[`geom_col`](https://ggplot2.tidyverse.org/reference/geom_bar.html)`(``fill ``=`` ``"#e6550d"``)`` ``+`` `` `[`coord_flip`](https://ggplot2.tidyverse.org/reference/coord_flip.html)`(``)`` ``+`` `` `[`labs`](https://ggplot2.tidyverse.org/reference/labs.html)`(`` `` x ``=`` ``NULL``, y ``=`` ``"Total contracted (BRL, millions)"``,`` `` title ``=`` ``"Ten largest ALEPE contractors"`` `` ``)`` ``+`` `` `[`theme_minimal`](https://ggplot2.tidyverse.org/reference/ggtheme.html)`(``)`

![](following-the-money_files/figure-html/unnamed-chunk-3-1.png)

## Contracts active today

Validity dates are parsed to `Date`, so filtering active contracts is a
one-liner:

`contracts`` ``|>`` `` `[`filter`](https://dplyr.tidyverse.org/reference/filter.html)`(``vigencia_inicio`` ``<=`` `[`Sys.Date`](https://rdrr.io/r/base/Sys.time.html)`(``)``, ``vigencia_fim`` ``>=`` `[`Sys.Date`](https://rdrr.io/r/base/Sys.time.html)`(``)``)`` ``|>`` `` `[`select`](https://dplyr.tidyverse.org/reference/select.html)`(``contratada``, ``objeto``, ``valor``, ``vigencia_fim``)`` ``|>`` `` `[`arrange`](https://dplyr.tidyverse.org/reference/arrange.html)`(``vigencia_fim``)`` ``#> ``# A tibble: 53 × 4`` ``#> contratada objeto valor vigencia_fim`` ``#> ``<chr>`` ``<chr>`` ``<dbl>`` ``<date>`` `` ``#> `` 1`` FRANCIELE ELETRO LTDA 5.000… 8.12``e``4 2026-08-18 `` ``#> `` 2`` V. S. COSTA & CIA LTDA 5.000… 1.7 ``e``4 2026-08-24 `` ``#> `` 3`` NORT MED PRODUTOS HOSPITALARES LTDA 5.000… 1.49``e``5 2026-08-28 `` ``#> `` 4`` R G DISTRIBUIDORA DE ALIMENTOS LTDA 5.000… 2.59``e``4 2026-09-03 `` ``#> `` 5`` 54.024.431 JEFFERSON PEREIRA MELO DO NAS… 5.000… 2.44``e``4 2026-09-03 `` ``#> `` 6`` MAPROS LTDA 5.000… 1.87``e``6 2026-09-08 `` ``#> `` 7`` GPB SERVICOS LTDA 5.000… 5.48``e``5 2026-09-17 `` ``#> `` 8`` IURY HERLEN DE SOUZA SANTOS LTDA 5.000… 5.33``e``6 2026-10-13 `` ``#> `` 9`` MCR SISTEMAS E CONSULTORIA LTDA 1.204… 5.71``e``5 2026-10-18 `` ``#> ``10`` INSTITUTO SAUDE EXPRESS 5.000… 3.28``e``6 2026-10-23 `` ``#> ``# ℹ 43 more rows`

## Procurement outcomes

`/licitacoes` is the slowest endpoint of the API — allow it half a
minute, and remember that a failed request yields a zero-row tibble
rather than an error:

`procurements`` ``<-`` `[`alepe_procurements`](https://strategicprojects.github.io/alepe/reference/alepe_procurements.md)`(``)`` ``#> Waiting 2s for retry backoff ``■■■■■■■■■■■■■■■■ `` ``#> Waiting 2s for retry backoff ``■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ `` ``#> Waiting 4s for retry backoff ``■■■■■■■■ `` ``#> Waiting 4s for retry backoff ``■■■■■■■■■■■■■■■ `` ``#> Waiting 4s for retry backoff ``■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ `` ``#> Warning in alepe_procurements(): ``!`` The ALEPE open data API could not be reached.`` ``#> ``ℹ```  Returning `NULL`. Original error: HTTP 500 Internal Server Error. ``` ``#> ``ℹ`` The service may be temporarily down; try again later.`` `[`nrow`](https://rdrr.io/r/base/nrow.html)`(``procurements``)`` ``#> [1] 0`

`procurements`` ``|>`` `` `[`count`](https://dplyr.tidyverse.org/reference/count.html)`(``ano``, ``status``)`` ``|>`` `` `[`ggplot`](https://ggplot2.tidyverse.org/reference/ggplot.html)`(`[`aes`](https://ggplot2.tidyverse.org/reference/aes.html)`(``x ``=`` ``ano``, y ``=`` ``n``, fill ``=`` ``status``)``)`` ``+`` `` `[`geom_col`](https://ggplot2.tidyverse.org/reference/geom_bar.html)`(``)`` ``+`` `` `[`labs`](https://ggplot2.tidyverse.org/reference/labs.html)`(`` `` x ``=`` ``NULL``, y ``=`` ``"Processes"``,`` `` fill ``=`` ``NULL``,`` `` title ``=`` ``"ALEPE procurement processes by year and status"`` `` ``)`` ``+`` `` `[`theme_minimal`](https://ggplot2.tidyverse.org/reference/ggtheme.html)`(``)`` ``+`` `` `[`theme`](https://ggplot2.tidyverse.org/reference/theme.html)`(``legend.position ``=`` ``"bottom"``)`` ``+`` `` `[`guides`](https://ggplot2.tidyverse.org/reference/guides.html)`(``fill ``=`` `[`guide_legend`](https://ggplot2.tidyverse.org/reference/guide_legend.html)`(``ncol ``=`` ``1``)``)`

> The ALEPE API did not return procurement processes while this page was
> being built, so the chart is omitted. Run the code above yourself for
> current data.

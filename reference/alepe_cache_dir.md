# Cache directory used by alepe

Responses from the ALEPE API are cached on disk to avoid repeated
downloads. The location follows
[`tools::R_user_dir()`](https://rdrr.io/r/tools/userdir.html), as
required by CRAN policy. Cached entries expire after
`getOption("alepe.cache_max_age", 6 * 3600)` seconds.

## Usage

``` r
alepe_cache_dir()

alepe_cache_clear()
```

## Value

The cache directory path, invisibly for `alepe_cache_clear()`.

## Examples

``` r
alepe_cache_dir()
#> [1] "/home/runner/.cache/R/alepe"
```

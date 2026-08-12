#' Emit an informational message unless silenced
#'
#' Messages are suppressed when `options(alepe.quiet = TRUE)` or in
#' non-interactive sessions unless verbosity is forced with
#' `options(alepe.quiet = FALSE)`.
#'
#' @param ... Passed to [cli::cli_inform()].
#' @noRd
alepe_inform <- function(...) {
  quiet <- getOption("alepe.quiet", default = !rlang::is_interactive())
  if (!isTRUE(quiet)) {
    cli::cli_inform(...)
  }
  invisible(NULL)
}

#' Normalize column names to snake_case
#'
#' Lowercases, transliterates accents, and squashes separators. Original
#' Portuguese words are kept (not translated) so columns remain traceable
#' to the official source.
#'
#' @param x A data frame or character vector of names.
#' @returns Same class as `x` with clean names.
#' @noRd
clean_names <- function(x) {
  nms <- if (is.data.frame(x)) names(x) else x
  nms <- enc2utf8(nms)
  # Explicit transliteration before tolower(): both iconv's //TRANSLIT
  # and tolower() on accented characters are locale-dependent (they fail
  # under the C locale, e.g. on some CRAN check machines).
  nms <- chartr(
    paste0(
      "\u00e1\u00e0\u00e2\u00e3\u00e4\u00e9\u00e8\u00ea\u00eb",
      "\u00ed\u00ec\u00ee\u00ef\u00f3\u00f2\u00f4\u00f5\u00f6",
      "\u00fa\u00f9\u00fb\u00fc\u00e7\u00f1",
      "\u00c1\u00c0\u00c2\u00c3\u00c4\u00c9\u00c8\u00ca\u00cb",
      "\u00cd\u00cc\u00ce\u00cf\u00d3\u00d2\u00d4\u00d5\u00d6",
      "\u00da\u00d9\u00db\u00dc\u00c7\u00d1"
    ),
    "aaaaaeeeeiiiiooooouuuucnAAAAAEEEEIIIIOOOOOUUUUCN",
    nms
  )
  nms <- tolower(nms)
  nms <- gsub("[^a-z0-9]+", "_", nms)
  nms <- gsub("^_+|_+$", "", nms)
  if (is.data.frame(x)) {
    names(x) <- nms
    x
  } else {
    nms
  }
}

#' Convert a JSON list-of-records into a clean tibble
#'
#' @param records List of named lists (one per row), possibly `NULL`.
#' @param schema Named character vector mapping clean column names to a
#'   type: `"chr"`, `"int"`, `"dbl"`, `"date"`, or `"brl"` (Brazilian
#'   currency/decimal strings such as `"1.234,56"`).
#' @returns A tibble with the schema's columns, typed; zero rows when
#'   `records` is `NULL` or empty.
#' @noRd
records_to_tibble <- function(records, schema) {
  empty <- empty_tibble(schema)
  if (is.null(records) || length(records) == 0L) {
    return(empty)
  }

  cols <- lapply(rlang::set_names(names(schema)), function(nm) {
    vapply(
      records,
      function(rec) {
        val <- rec[[match_field(nm, names(rec))]]
        if (is.null(val)) NA_character_ else enc2utf8(as.character(val))
      },
      character(1)
    )
  })

  out <- tibble::as_tibble(cols)
  parse_schema(out, schema)
}

#' @noRd
match_field <- function(clean, raw_names) {
  hit <- which(clean_names(raw_names) == clean)
  if (length(hit) == 0L) NA_integer_ else hit[[1L]]
}

#' @noRd
parse_schema <- function(df, schema) {
  for (nm in names(schema)) {
    df[[nm]] <- switch(schema[[nm]],
      chr = df[[nm]],
      int = as.integer(readr::parse_number(
        df[[nm]],
        locale = brl_locale()
      )),
      dbl = readr::parse_number(df[[nm]], locale = brl_locale()),
      brl = readr::parse_number(df[[nm]], locale = brl_locale()),
      date = parse_br_date(df[[nm]]),
      df[[nm]]
    )
  }
  df
}

#' @noRd
brl_locale <- function() {
  readr::locale(decimal_mark = ",", grouping_mark = ".")
}

#' Parse dates in either dd/mm/yyyy or ISO format
#' @noRd
parse_br_date <- function(x) {
  out <- as.Date(rep(NA_character_, length(x)))
  iso <- grepl("^\\d{4}-\\d{2}-\\d{2}", x)
  br <- grepl("^\\d{2}/\\d{2}/\\d{4}", x)
  out[iso] <- as.Date(substr(x[iso], 1, 10), format = "%Y-%m-%d")
  out[br] <- as.Date(substr(x[br], 1, 10), format = "%d/%m/%Y")
  out
}

#' @noRd
empty_tibble <- function(schema) {
  proto <- lapply(schema, function(type) {
    switch(type,
      chr = character(),
      int = integer(),
      dbl = numeric(),
      brl = numeric(),
      date = as.Date(character()),
      character()
    )
  })
  tibble::as_tibble(proto)
}

#' Map user-facing status values to API `vinculo` values
#'
#' Accepts both the English package vocabulary and the original
#' Portuguese API terms.
#'
#' @param status `NULL` (no filter) or one of `"permanent"`,
#'   `"commissioned"`, `"seconded"`, `"efetivo"`, `"comissionado"`,
#'   `"a-disposicao"`.
#' @returns The API value, or `NULL`.
#' @noRd
map_status <- function(status, error_call = rlang::caller_env()) {
  if (is.null(status)) {
    return(NULL)
  }
  map <- c(
    permanent = "efetivo",
    commissioned = "comissionado",
    seconded = "a-disposicao",
    efetivo = "efetivo",
    comissionado = "comissionado",
    `a-disposicao` = "a-disposicao"
  )
  status <- rlang::arg_match(status, names(map), error_call = error_call)
  unname(map[[status]])
}

#' Report the result of a fetch
#' @noRd
report_rows <- function(df, what) {
  if (!is.null(df)) {
    alepe_inform(c("v" = "Fetched {nrow(df)} row{?s} of {what}."))
  }
  invisible(df)
}

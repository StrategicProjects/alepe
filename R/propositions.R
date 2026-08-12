#' Query legislative propositions
#'
#' Retrieves legislative propositions from the Assembly: bills
#' (`alepe_bills()`), indications (`alepe_indications()`), and requests
#' (`alepe_requests()`). Two query modes are supported by the API:
#'
#' * **Detail**: pass `number` and `year` to fetch the full record of a
#'   single proposition.
#' * **Listing**: pass `year` and/or `legislature` to fetch summaries of
#'   multiple propositions. When no filter is given, the API defaults to
#'   the current year.
#'
#' These endpoints serve structured data as XML or CSV; the package uses
#' CSV and parses it with UTF-8 encoding, returning the columns provided
#' by the API with names normalized to snake_case.
#'
#' @param number Proposition number, for the detail mode. Requires
#'   `year`.
#' @param year Filter by year (listing mode) or select the proposition
#'   (detail mode).
#' @param legislature Filter by legislature number (listing mode).
#' @param refresh If `TRUE`, bypass the local cache.
#' @returns A tibble, or a zero-column tibble (with a warning) on
#'   network failure.
#' @examplesIf interactive()
#' # All bills of the current year
#' alepe_bills()
#'
#' # One specific bill
#' alepe_bills(number = 100, year = 2024)
#' @export
alepe_bills <- function(number = NULL, year = NULL, legislature = NULL,
                        refresh = FALSE) {
  alepe_proposition(
    "projetos", "bills",
    number = number, year = year, legislature = legislature,
    refresh = refresh
  )
}

#' @rdname alepe_bills
#' @export
alepe_indications <- function(number = NULL, year = NULL,
                              legislature = NULL, refresh = FALSE) {
  alepe_proposition(
    "indicacoes", "indications",
    number = number, year = year, legislature = legislature,
    refresh = refresh
  )
}

#' @rdname alepe_bills
#' @export
alepe_requests <- function(number = NULL, year = NULL, legislature = NULL,
                           refresh = FALSE) {
  alepe_proposition(
    "requerimentos", "requests",
    number = number, year = year, legislature = legislature,
    refresh = refresh
  )
}

#' @noRd
alepe_proposition <- function(type, what, number, year, legislature,
                              refresh = FALSE,
                              error_call = rlang::caller_env()) {
  if (!is.null(number) && is.null(year)) {
    cli::cli_abort(
      c(
        "!" = "{.arg number} requires {.arg year}.",
        "i" = "The detail mode of the propositions API selects a single
               proposition by number {.emph and} year."
      ),
      class = "alepe_error_input",
      call = error_call
    )
  }

  out <- alepe_fetch_csv(
    file.path("proposicoes", type),
    numero = number,
    ano = year,
    legislatura = legislature,
    refresh = refresh,
    error_call = error_call
  )

  if (is.null(out)) {
    return(tibble::tibble())
  }

  out <- clean_names(out)
  report_rows(out, what)
}

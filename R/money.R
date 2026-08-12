#' List administrative contracts
#'
#' Retrieves the Assembly's administrative contracts, including
#' modality, contract number and year, contractor name and tax id
#' (CPF/CNPJ), object, value, and validity period.
#'
#' @inheritParams alepe_representatives
#' @returns A tibble with one row per contract. Monetary values are
#'   parsed to numeric (BRL) and validity dates to `Date`. Zero rows
#'   (with a warning) on network failure.
#' @examplesIf interactive()
#' alepe_contracts()
#' @export
alepe_contracts <- function(refresh = FALSE) {
  schema <- c(
    modalidade = "chr", numero = "chr", ano = "int",
    razao_social = "chr", cpf_cnpj = "chr", objeto = "chr",
    valor = "brl", inicio_vigencia = "date", fim_vigencia = "date"
  )
  records <- alepe_fetch_json("contratos", refresh = refresh)
  out <- records_to_tibble(records, schema)
  report_rows(out, "contracts")
}

#' List procurement processes
#'
#' Retrieves the Assembly's procurement (bidding) processes, including
#' process number and year, public notice date, modality, object,
#' estimated value, and status.
#'
#' @inheritParams alepe_representatives
#' @returns A tibble with one row per procurement process. Zero rows
#'   (with a warning) on network failure.
#' @examplesIf interactive()
#' alepe_procurements()
#' @export
alepe_procurements <- function(refresh = FALSE) {
  schema <- c(
    numero_processo = "chr", ano = "int", data_edital = "date",
    modalidade = "chr", objeto = "chr", valor_estimativo = "brl",
    situacao = "chr"
  )
  records <- alepe_fetch_json("licitacoes", refresh = refresh)
  out <- records_to_tibble(records, schema)
  report_rows(out, "procurement processes")
}

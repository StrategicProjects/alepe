test_that("clean_names normalizes accents, case and separators", {
  expect_equal(
    clean_names(c("NOME_LOTAÇÃO", "CARGO NÍVEL", "CPF/CNPJ ")),
    c("nome_lotacao", "cargo_nivel", "cpf_cnpj")
  )
})

test_that("map_status accepts English and Portuguese vocabularies", {
  expect_null(map_status(NULL))
  expect_equal(map_status("permanent"), "efetivo")
  expect_equal(map_status("efetivo"), "efetivo")
  expect_equal(map_status("seconded"), "a-disposicao")
  expect_error(map_status("nope"), class = "rlang_error")
})

test_that("records_to_tibble builds typed tibbles and handles NULL", {
  schema <- c(nome = "chr", total = "int", valor = "brl", inicio = "date")

  empty <- records_to_tibble(NULL, schema)
  expect_s3_class(empty, "tbl_df")
  expect_equal(nrow(empty), 0L)
  expect_type(empty$total, "integer")
  expect_s3_class(empty$inicio, "Date")

  recs <- list(
    list(
      NOME = "ANA", TOTAL = "12",
      VALOR = "1.234,56", INICIO = "01/02/2024"
    ),
    list(NOME = "BIA", TOTAL = "3", VALOR = "10,00", INICIO = "2024-03-05")
  )
  out <- records_to_tibble(recs, schema)
  expect_equal(out$total, c(12L, 3L))
  expect_equal(out$valor, c(1234.56, 10))
  expect_equal(out$inicio, as.Date(c("2024-02-01", "2024-03-05")))
})

test_that("missing fields become NA, extra fields are ignored", {
  schema <- c(nome = "chr", email = "chr")
  recs <- list(list(NOME = "ANA", PARTIDO = "XYZ"))
  out <- records_to_tibble(recs, schema)
  expect_equal(out$nome, "ANA")
  expect_true(is.na(out$email))
  expect_named(out, c("nome", "email"))
})

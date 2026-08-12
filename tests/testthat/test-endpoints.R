# Endpoint parsing tests against local fixtures built from the examples
# in the official API documentation.
#
# To (re)record real fixtures locally, run once with network access:
#
#   httptest2::start_capturing()
#   alepe_representatives(refresh = TRUE)
#   alepe_staff(refresh = TRUE)
#   # ... one call per endpoint ...
#   httptest2::stop_capturing()
#
# and switch these tests to httptest2::with_mock_dir().

fixture_json <- function(name) {
  # jsonlite is a hard dependency of httr2, so it is always available.
  jsonlite::read_json(testthat::test_path("fixtures", name))
}

test_that("staff fixture parses into documented schema", {
  records <- fixture_json("servidores.json")
  local_mocked_bindings(alepe_fetch_json = function(...) records)

  out <- alepe_staff()
  expect_s3_class(out, "tbl_df")
  expect_gt(nrow(out), 0L)
  expect_named(
    out,
    c(
      "seq", "nome", "codigo_lotacao", "nome_lotacao",
      "cargo_nivel", "vinculo", "situacao"
    )
  )
  expect_equal(out$vinculo[[1]], "Efetivo")
})

test_that("positions fixture parses totals as integers", {
  records <- fixture_json("cargos.json")
  local_mocked_bindings(alepe_fetch_json = function(...) records)

  out <- alepe_positions()
  expect_type(out$total, "integer")
  expect_true(all(out$total > 0L))
})

test_that("departments fixture parses into documented schema", {
  records <- fixture_json("lotacoes.json")
  local_mocked_bindings(alepe_fetch_json = function(...) records)

  out <- alepe_departments()
  expect_named(out, c("total", "nome_lotacao", "vinculo"))
  expect_type(out$total, "integer")
})

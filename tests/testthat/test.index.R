context("Index function")

test_that("index works properly", {
  expect_error(
    economics_long %>%
      mutate(val = index(value, date, min(date)))
  )
  expect_known_value(
    economics_long %>%
      group_by(variable) %>%
      mutate(val = index(value, date, min(date))),
    file = "economics_index"
  )
})

context("external data sources")
library(tidyverse)
library(HMSr)


test_that("get_vnv returns the right results", {
  expect_is(get_vnv(), "tbl")
  expect_known_output(head(get_vnv(), 100), file = "vnv_data", print = TRUE)
})

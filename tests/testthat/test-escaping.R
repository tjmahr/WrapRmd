context("escaping.R")

test_that("does not escape !, [, ]", {
  string <- "This is a confidence interval [0, 1], [0, 1]!"
  expect_equal(str_rmd_wrap(string), string)
})

test_that("does not escape !, [, ] unless they are already escaped", {
  string <- "This is a confidence interval [0, 1]! \\[0, 1\\]\\!"
  expect_equal(str_rmd_wrap(string), string)
})

test_that("does not unescape \\@ref", {
  string <- "Table \\@ref(tab:counts) shows counts; @ref(tab:counts) won't."
  expect_equal(str_rmd_wrap(string), string)
})



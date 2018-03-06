context("test-options.R")

test_that("wrapping can use options()", {
  # Default is 80
  long_paragraph <-
"`r hello` and `r 1 + 1` and `r 1 + b + b + c`---and drop a line right here `r maybe_here` `r goodbye`"

  wrap_80 <-
"`r hello` and `r 1 + 1` and `r 1 + b + b + c`---and drop a line right here
`r maybe_here` `r goodbye`"

  expect_equal(str_rmd_wrap(long_paragraph), wrap_80)

  options(WrapRmd.width = 40)

  wrap_40 <-
"`r hello` and `r 1 + 1` and
`r 1 + b + b + c`---and drop a line
right here `r maybe_here` `r goodbye`"

  expect_equal(str_rmd_wrap(long_paragraph), wrap_40)

  options(WrapRmd.width = 80)
})

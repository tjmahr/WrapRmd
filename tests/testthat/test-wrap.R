context("wrap.R")

test_that("basic wrapping", {
  no_code <- "regular words on a line"
  expect_equal(str_rmd_wrap(no_code), no_code)

  long_paragraph <- "`r hello` and `r 1 + 1` and `r 1 + b + b + c` and drop a line right here `r maybe_here` `r goodbye`"

  long_paragraph_wrap <-
"`r hello` and `r 1 + 1` and `r 1 + b + b + c` and drop a line right here
`r maybe_here` `r goodbye`"

  expect_equal(str_rmd_wrap(long_paragraph), long_paragraph_wrap)

  # The lines from the gif
  gif_lines <- "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum a `r max(iris$Sepal.Length)`, viverra nisl at, luctus ante = `r length(letters) * 2 + 100`."

  gif_lines_wrap <-
"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum a
`r max(iris$Sepal.Length)`, viverra nisl at, luctus ante =
`r length(letters) * 2 + 100`."

  expect_equal(str_rmd_wrap(gif_lines), gif_lines_wrap)
})


test_that("does not break links (#7)", {
  string <- "
It's very easy to make some words **bold** and a [link to Google!](http://google.com)!
"

  string2 <- "
It's very easy to make some words **bold** and a [link to
Google!](http://google.com)!
"

  expect_equal(str_rmd_wrap(string), string2)
})


test_that("preserve paragraphs", {
  paragraph_preserving <-
"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum a `r max(iris$Sepal.Length)`, viverra nisl at, luctus ante = `r length(letters) * 2 + 100`.

`r hello` and `r 1 + 1` and `r 1 + b + b + c` and drop a line right here `r maybe_here` `r goodbye`


hello"

  paragraph_preserving_wrapped <-
"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum a
`r max(iris$Sepal.Length)`, viverra nisl at, luctus ante =
`r length(letters) * 2 + 100`.

`r hello` and `r 1 + 1` and `r 1 + b + b + c` and drop a line right here
`r maybe_here` `r goodbye`


hello"

  expect_equal(str_rmd_wrap(paragraph_preserving), paragraph_preserving_wrapped)

  # leading blank lines are preserved
  paragraphs_ssttst <-
"

text in p1.
extra text in p1.

text in p2."

  paragraphs_ssttst_wrapped <-
"

text in p1. extra text in p1.

text in p2."

  expect_equal(str_rmd_wrap(paragraphs_ssttst), paragraphs_ssttst_wrapped)

  # trailing blank lines are preserved
  paragraphs_sttstss <-
"
text in p1.
extra text in p1.

text in p2.

"

  paragraphs_sttstss_wrapped <-
"
text in p1. extra text in p1.

text in p2.

"

  expect_equal(str_rmd_wrap(paragraphs_sttstss), paragraphs_sttstss_wrapped)


  # trailing blank lines are preserved
  paragraphs_sttsts <-
"
text in p1.
extra text in p1.

text in p2.
"

  paragraphs_sttsts_wrapped <-
"
text in p1. extra text in p1.

text in p2.
"
  expect_equal(str_rmd_wrap(paragraphs_sttsts), paragraphs_sttsts_wrapped)
})

test_that("set column width directly", {
  long_paragraph <- paste(sprintf("a%02d", 3 + 4 * 0:20) , collapse = " ")

  long_paragraph_wrap_10 <-
"a03 a07
a11 a15
a19 a23
a27 a31
a35 a39
a43 a47
a51 a55
a59 a63
a67 a71
a75 a79
a83"
  long_paragraph_wrap_40 <-
"a03 a07 a11 a15 a19 a23 a27 a31 a35 a39
a43 a47 a51 a55 a59 a63 a67 a71 a75 a79
a83"
  long_paragraph_wrap_default <-
"a03 a07 a11 a15 a19 a23 a27 a31 a35 a39 a43 a47 a51 a55 a59 a63 a67 a71 a75 a79
a83"
  expect_equal(str_rmd_wrap(long_paragraph, 10), long_paragraph_wrap_10)
  expect_equal(str_rmd_wrap(long_paragraph, 40), long_paragraph_wrap_40)
  expect_equal(str_rmd_wrap(long_paragraph), long_paragraph_wrap_default)
})

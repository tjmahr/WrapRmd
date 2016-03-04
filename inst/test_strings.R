library("stringr")

no_code <- "regular words on a line"
str_rmd_wrap(no_code) %>% cat

# Simple case
text <- "
`r hello` and `r 1 + 1` and `r 1 + b + b + c` and drop a line right here `r maybe_here` `r goodbye`
"
str_rmd_wrap(text) %>% cat




string <- paragraphs_sttsts <-
"
text in p1.
extra text in p1.

text in p2.
"




# Eventually, make a way to associate strings with their expected paragraph
# wrapping...

# "text\n\ntext" would have an expected wrapping of "psp" (a paragraph, a
# paragraph separation, a paragraph)

# test_string <- function(string, expected_wrapping) {
#   list(string = string, expected = expected_wrapping, received = f(string))
# }
#
# get_paragraph_wrapping <- function(string) {
#   string %>% str_split()
# }


library("stringr")

no_code <- "regular words on a line"
str_rmd_wrap(no_code) %>% cat

# Simple case
text <- "
`r hello` and `r 1 + 1` and `r 1 + b + b + c` and drop a line right here `r maybe_here` `r goodbye`
"
str_rmd_wrap(text) %>% cat

# Paragraph I got frustrated manually re-wrapping
original_test <- "
Ignoring the quadratic and cubic features of the growth curve, the linear time^1^ term estimated an increase of `r ms_delta_bin` logits per 50 ms. At 0 logits (.5 proportion units), where the logistic function is steepest, an increase of `r ms_delta_bin` logits corresponds to an increase of `r ms_prop_change_50` proportion units. At chance performance (.25 proportion units), this effect corresponds to an increase of `r ms_prop_change_25` proportion units.
"

str_rmd_wrap(original_test) %>% cat


gif_lines <- "
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum a `r max(iris$Sepal.Length)`, viverra nisl at, luctus ante = `r length(letters) * 2 + 100`.
"

str_rmd_wrap(gif_lines) %>% cat

paragraph_preserving <- "
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum a `r max(iris$Sepal.Length)`, viverra nisl at, luctus ante = `r length(letters) * 2 + 100`.

`r hello` and `r 1 + 1` and `r 1 + b + b + c` and drop a line right here `r maybe_here` `r goodbye`


hello

"
paragraph_preserving %>% str_rmd_wrap %>% cat

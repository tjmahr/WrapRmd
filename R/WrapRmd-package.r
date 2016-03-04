#' WrapRmd
#'
#' Provides an RStudio addin for wrapping paragraphs in an RMarkdown document
#' without inserting linebreaks into spans of inline R code.
#'
#' @name WrapRmd
#' @docType package
#' @import stringr
NULL


#' Wrap text but don't insert lines breaks into inline R code
#'
#' Call this addin to wrap paragraphs in an R Markdown document.
#'
#' @export
wrap_rmd_addin <- function() {
  context <- rstudioapi::getActiveDocumentContext()
  selection <- context$selection
  text <- unlist(selection)["text"]
  rstudioapi::insertText(str_rmd_wrap(text))
}


#' Wrap text but don't insert lines breaks into inline R code
#' @param string a string to wrap
#' @param width,indent,exdent other arguments for stringr::str_wrap
#' @return a wrapped copy of the string
#'
#' @details This function finds all inline R code spans in a string, replaces
#'   all non-word characters in the R spans with underscores, re-wraps the
#'   string, and restores the original inline R spans. This function cannot
#'   handle any inline code that uses backticks.
#' @export
str_rmd_wrap <- function(string, width = 80, indent = 0, exdent = 0) {
  # Two paragraphs are separated by [line break [spaces] line break]. Find those
  # points.
  paragraph_seps <- string %>%
    str_extract_all("\\n\\s*\\n") %>%
    unlist

  # Split at those points to get paragraphs.
  paragraphs <- string %>%
    str_split("\\n\\s*\\n") %>%
    unlist %>%
    unname

  # Wrap each paragraph.
  paragraphs <- Map(str_rmd_wrap_one, paragraphs) %>%
    unlist %>%
    unname

  str_interleave(paragraphs, paragraph_seps)
}


str_interleave <- function(strings, interleaves) {
  if (length(strings) == 1) return(strings)
  stopifnot(length(strings) - length(interleaves) == 1)

  # Pop the first string off. Concatenate pairs of interleaves and strings.
  start <- head(strings, 1)
  left <- tail(strings, -1)
  body <- paste0(paste0(interleaves, left, collapse = ""))

  # Reattach head
  paste0(start, body)
}


str_rmd_wrap_one <- function(string, width = 80, indent = 0, exdent = 0) {
  stopifnot(length(string) == 1)
  output <- string

  inline_code <- str_extract_all(string, "(`r)( )([^`]+`)") %>% unlist

  # Just wrap if no code
  if (length(inline_code) == 0) {
    return(str_wrap(string, width, indent, exdent))
  }

  # Make R code spans into long words
  spaceless_code <- inline_code %>% str_replace_all("\\W| ", "_")

  for (i in seq_along(inline_code)) {
    output <- str_replace(output, coll(inline_code[i]), spaceless_code[i])
  }

  # Wrap
  output <- str_wrap(output, width, indent, exdent)

  # Put original code spans back
  for (i in seq_along(inline_code)) {
    output <- stringi::stri_replace_first_coll(
      str = output,
      pattern = spaceless_code[i],
      replacement = inline_code[i])
  }

  output
}


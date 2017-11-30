#' WrapRmd
#'
#' Provides an RStudio addin for wrapping paragraphs in an RMarkdown document
#' without inserting linebreaks into spans of inline R code.
#'
#' @name WrapRmd
#' @docType package
#' @import stringr
#' @importFrom utils head tail
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
#'
#' @param string a string to wrap
#' @param width desired line width. Defaults to 80 characters.
#' @return a wrapped copy of the string
#'
#' @details This function finds all inline R code spans in a string, replaces
#'   all non-word characters in the R spans with `"Q"`s, re-wraps the
#'   string, and restores the original inline R spans.
#'
#'   This function preserves blanks lines between paragraphs.
#' @export
str_rmd_wrap <- function(string, width = 80) {
  # Assume paragraphs are separated by [newline][optional spaces][newline].
  re_paragraph_sep <- "(\\n\\s*\\n)"

  # Need to preserve blank lines at start and end
  re_blanks_at_start <- "(^\\s*\\n)"
  re_blanks_at_close <- "(\\s*\\n$)"

  re_start_or_sep_or_close <- paste(
    re_blanks_at_start,
    re_paragraph_sep,
    re_blanks_at_close,
    sep = "|")

  # Find paragraph separations
  paragraph_seps <- string %>%
    str_extract_all(re_start_or_sep_or_close) %>%
    unlist()

  # Split at those points to get paragraphs.
  paragraphs <- string %>%
    str_split(re_start_or_sep_or_close) %>%
    unlist %>%
    unname()

  # Wrap each paragraph.
  paragraphs <- Map(str_rmd_wrap_one, paragraphs) %>%
    unlist %>%
    unname()

  str_interleave(paragraphs, paragraph_seps)
}


# Interleave two vectors of strings
str_interleave <- function(strings, interleaves) {
  if (length(strings) == 1) return(strings)
  stopifnot(length(strings) - length(interleaves) == 1)

  # Pop the first string off. Concatenate pairs of interleaves and strings.
  start <- head(strings, 1)
  left <- tail(strings, -1)
  body <- paste0(interleaves, left, collapse = "")

  # Reattach head
  paste0(start, body)
}


str_rmd_wrap_one <- function(string, width = 80) {
  output <- string

  re_inline_code <- "(`r)( )([^`]+`)"
  re_nonword <- "\\W|_"

  inline_code <- string %>%
    str_extract_all(re_inline_code) %>%
    unlist()

  # Just wrap if no code
  if (length(inline_code) == 0) {
    return(md_wrap(string, width))
  }

  # Make R code spans into long words

  # I used to replace with "_" but md_wrap() escapes them as "\\_" which messes
  # up the line width
  spaceless_code <- str_replace_all(inline_code, re_nonword, "Q")

  for (i in seq_along(inline_code)) {
    output <- str_replace(output, coll(inline_code[i]), spaceless_code[i])
  }

  # Wrap
  output <- md_wrap(output, width)

  # Put original code spans back
  for (i in seq_along(inline_code)) {
    output <- stringi::stri_replace_first_coll(
      str = output,
      pattern = md_wrap(spaceless_code[i]),
      replacement = inline_code[i])
  }

  output
}


md_wrap <- function (string, width = 80, ...) {
  string %>%
    commonmark::markdown_commonmark(
      hardbreaks = FALSE,
      extensions = TRUE,
      normalize = FALSE,
      width = 80) %>%
    str_replace("\\n$", "") %>%
    stringi::stri_replace_all_regex("\\\\(!(?!\\[))", "$1")
}

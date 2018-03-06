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


md_wrap <- function(string, width = 80, hardbreaks = FALSE, smart = FALSE,
                    normalize = FALSE, extensions = TRUE) {
  raw_string <- string
  width <- getOption("WrapRmd.width", width)
  smart <- getOption("WrapRmd.smart", smart)
  extensions <- getOption("WrapRmd.extensions", extensions)

  wrapped <- string %>%
    commonmark::markdown_commonmark(
      hardbreaks = hardbreaks,
      extensions = extensions,
      normalize = normalize,
      smart = smart,
      width = width) %>%
    str_replace("\\n$", "")

  wrapped %>%
    unescape(raw_string, "[") %>%
    unescape(raw_string, "]") %>%
    unescape(raw_string, "!") %>%
    restore_escape(raw_string, "\\@ref")
}

restore_escape <- function(string, raw_string, target) {
  # Find any instances of the unescaped form in the text
  location_in_raw <- str_locate_all(raw_string, unesc(target))[[1]] %>%
    as.data.frame()

  # Check each use of see if it was escaped in the raw string
  for (i in seq_along(location_in_raw$start)) {
    char_loc <- location_in_raw$start[[i]]
    char_end <- location_in_raw$end[[i]]
    escaped <- substr(raw_string, char_loc - 1, char_end) == target
    location_in_raw$escaped[[i]] <- escaped
  }

  # Find the target in the wrapped string
  location_in_wrapped <- str_locate_all(string, unesc(target))[[1]] %>%
    as.data.frame()

  # Check for corruptions in the wrapped text
  for (i in seq_along(location_in_wrapped[, 1])) {
    char_loc <- location_in_wrapped$start[[i]]
    char_end <- location_in_wrapped$end[[i]]
    escaped_in_wrapped <- substr(string, char_loc - 1, char_end) == target
    escaped_in_raw <- location_in_raw$escaped[[i]]

    # If escape removed, add it and update target locations
    if (!escaped_in_wrapped & escaped_in_raw) {
      str_sub(string, char_loc, char_end) <- target
      location_in_wrapped <- str_locate_all(string, unesc(target))[[1]] %>%
        as.data.frame()
    }
  }

  string
}

unescape <- function(string, raw_string, target) {
  # Find the target in the original string
  location_in_raw <- str_locate_all(raw_string, esc(target))[[1]] %>%
    as.data.frame()

  # Check each use of target to see if it was exepcted in the raw string
  for (i in seq_along(location_in_raw$start)) {
    char_loc <- location_in_raw$start[[i]]
    escaped <- substr(raw_string, char_loc - 1, char_loc) == esc(target)
    location_in_raw$escaped[[i]] <- escaped
  }

  # Find the target in the wrapped string
  location_in_wrapped <- str_locate_all(string, esc(target))[[1]]

  # Check for escapes in the wrapped text
  for (i in seq_along(location_in_wrapped[, 1])) {
    char_loc <- location_in_wrapped[i, 1]
    escaped_in_wrapped <- substr(string, char_loc - 1, char_loc) == esc(target)
    escaped_in_raw <- location_in_raw$escaped[[i]]

    # If an escape was added, remove it and update target locations
    if (escaped_in_wrapped & !escaped_in_raw) {
      str_sub(string, char_loc - 1, char_loc) <- target
      location_in_wrapped <- str_locate_all(string, esc(target))[[1]]
    }
  }

  string
}

esc <- function(x) {
  paste0("\\", x)
}

unesc <- function(x) {
  str_replace(x, "^\\\\", "")
}

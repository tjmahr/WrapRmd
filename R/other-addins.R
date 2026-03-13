#' Run selection through knitr and commonmark
#'
#' Call this addin to preview output of an R markdown selection.
#'
#' @export
knit_selection_addin <- function() {
  context <- rstudioapi::getActiveDocumentContext()
  selection <- context$selection

  text <- unlist(selection)["text"]
  cat(
    commonmark::markdown_commonmark(
      knitr::knit(text = text, quiet = TRUE)
    )
  )
}


#' Convert back slashes to forward slashes
#'
#' Call this addin to convert `\\drive\folder` to `//drive/folder`
#'
#' @export
flip_backslashes_addin <- function() {
  context <- rstudioapi::getActiveDocumentContext()
  selection <- context$selection
  text <- unlist(selection)["text"]
  rstudioapi::insertText(stringr::str_replace_all(text, "\\\\", "/"))
}


#' Assign argument defaults
#'
#' Evaluates all comma-separated `x = y` expressions in a selection. The
#' intended usage is for selecting all of the text between the parentheses in a
#' `function(text = "to", select = "and", evaluate)` call so that default
#' arguments values can be assigned to a user's global environment.
#'
#' @export
assign_argument_defaults_addin <- function() {
  context <- rstudioapi::getActiveDocumentContext()
  selection <- context$selection
  text <- unlist(selection)["text"]
  result <- parse_argument_text_and_eval(text)

  if (length(result) == 0L) {
    message("No default assignments found in selection.")
  } else {
    message("Assigned: ", paste(result, collapse = ", "))
  }

  invisible(result)
}

parse_argument_text_and_eval <- function(text, env = .GlobalEnv) {
  stopifnot(is.character(text), length(text) == 1L)
  stopifnot(is.environment(env))

  # Trim trailing commas
  t <- stringr::str_remove(text, ",+\\s*$")

  parsed_formals <- tryCatch(
    eval(parse(text = paste0("formals(function(", t, ") NULL)"))),
    error = function(e) {
      stop(
        "Could not parse selection as a function argument list: ",
        conditionMessage(e),
        call. = FALSE
      )
    }
  )

  # Remove arguments with no defaults
  parsed_formals <- parsed_formals |>
    Filter(function(expr) !identical(expr, quote(expr = )), x = _)

  assigned <- character(0)
  for (i in seq_along(parsed_formals)) {
    value <- eval(parsed_formals[[i]], envir = env)
    nm <- names(parsed_formals)[i]
    assign(nm, value, envir = env)
    assigned <- c(assigned, nm)
  }

  invisible(assigned)
}


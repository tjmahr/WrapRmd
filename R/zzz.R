.onLoad <- function(libname, pkgname) {
  op <- options()
  op_WrapRmd <- list(
    WrapRmd.width = 80,
    WrapRmd.smart = FALSE,
    WrapRmd.extensions = TRUE
  )
  toset <- !(names(op_WrapRmd) %in% names(op))
  if (any(toset)) options(op_WrapRmd[toset])

  invisible()
}

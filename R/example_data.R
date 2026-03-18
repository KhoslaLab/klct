#' Get path to klct examples
#'
#' klct comes bundled with some example files in its `inst/extdata`
#' directory. This function makes them easy to access.
#'
#' Adapted from [readxl::readxl_example()].
#'
#' @param path Name of file. If `NULL`, the example files will be listed.
#'
#' @return A string containing the name of the file, or a character vector
#'   containing the names of all example files.
#' @export
#'
#' @examples
#' klct_ex()
#' klct_ex("mouse-table.csv")
klct_ex <- function(path = NULL) {
    if (is.null(path)) {
        dir(system.file("extdata", package = "klct"))
    } else {
        system.file("extdata", path, package = "klct", mustWork = TRUE)
    }
}

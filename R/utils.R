#' Update klct
#'
#' This is a convenience function wrapper around [remotes::install_github()] to
#' install/update `klct`. Meant to be used as an RStudio addin.
#'
#' @export
#'
#' @examplesIf FALSE
#' update_klct()
update_klct <- function() {
    remotes::install_github("KhoslaLab/klct")
}

# Housekeeping to silence note in R CMD check due to use of unquoted symbols in
# code using dplyr
utils::globalVariables(
    c(
        "AS",
        "Genotype",
        "Group",
        "Measure",
        "Sex",
        "Sig",
        "Site",
        "Treatment",
        "Value"
    )
)

# Use of these functions in the R Markdown template is integral to the package's
# core functionality
ignore_unused_imports <- function() {
    xfun::embed_file
    sessioninfo::session_info
    mayodown::mayohtml
}

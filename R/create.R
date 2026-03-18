#' Create a project skeleton to compare bone microCT data
#'
#' These functions assume you are in a project root directory and create an R
#' Markdown file containing a pre-filled bone microCT analysis. They create
#' the analysis R Markdown file using the appropriate package template.
#'
#' `create_two_treatment_comparison()` creates a template for comparing two
#' treatment groups, analyzing each sex separately.
#'
#' `create_two_treatment_two_sex_comparison()` creates a template for a full
#' two-way (Treatment x Sex) analysis.
#'
#' Both functions accept a `mayo` argument. When `mayo = TRUE`, the template
#' uses `mayodown::mayohtml` for a Mayo-themed report. When `mayo = FALSE`
#' (the default), the template uses `rmarkdown::html_document`.
#'
#' @param file_name A string to name the project analysis R Markdown document.
#'   Defaults to a file in the style of `"YYYY-MM-DD-microCT-Analysis.Rmd"`,
#'   where `YYYY-MM-DD` represents today's date.
#' @param mayo Logical. If `TRUE`, create a Mayo-themed template using
#'   `mayodown::mayohtml`. If `FALSE` (the default), use
#'   `rmarkdown::html_document`.
#'
#' @return Returns `TRUE` if successful.
#' @export
#'
#' @examplesIf FALSE
#' create_two_treatment_comparison()
#' create_two_treatment_comparison(mayo = TRUE)
#' create_two_treatment_two_sex_comparison()
#' create_two_treatment_two_sex_comparison(mayo = TRUE)
create_two_treatment_comparison <- function(
    file_name = paste0(format(Sys.Date(), "%F"), "-microCT-Analysis.Rmd"),
    mayo = FALSE
) {
    template_dir <- if (mayo) "two-treatments-mayo" else "two-treatments"
    file.copy(
        from = system.file("rmarkdown", "templates", template_dir,
                           "skeleton", "skeleton.Rmd",
                           package = "klct"),
        to = here::here(file_name)
    )
}

#' @rdname create_two_treatment_comparison
#' @export
create_two_treatment_two_sex_comparison <- function(
    file_name = paste0(format(Sys.Date(), "%F"), "-microCT-Analysis.Rmd"),
    mayo = FALSE
) {
    template_dir <- if (mayo) "two-treatments-two-sexes-mayo" else "two-treatments-two-sexes"
    file.copy(
        from = system.file("rmarkdown", "templates", template_dir,
                           "skeleton", "skeleton.Rmd",
                           package = "klct"),
        to = here::here(file_name)
    )
}

#' Render an R Markdown document with colored text
#'
#' This function is a wrapper around [rmarkdown::render()] which supplies the
#' Lua Pandoc filter from the [mayodown][mayodown::mayohtml] package to color
#' text. It is used as the `knit` function in the standard (non-Mayo) R
#' Markdown templates.
#'
#' @param input The input file to be rendered.
#' @param ... Additional arguments passed on to [rmarkdown::render()].
#'
#' @return As for [rmarkdown::render()], when `run_pandoc = TRUE`, the compiled
#'   document is written into the output file, and the path of the output file
#'   is returned. When `run_pandoc = FALSE`, the path of the Markdown output
#'   file, with attributes `knit_meta` (the knitr meta data collected from code
#'   chunks) and `intermediates` (the intermediate files/directories generated
#'   by [rmarkdown::render()]).
#' @export
#'
#' @examplesIf FALSE
#' knit_with_colored_text("example_file.Rmd")
knit_with_colored_text <- function(input, ...) {
    lua_filter <- rmarkdown::pandoc_lua_filter_args(
        system.file("pandoc", "color-text.lua", package = "mayodown")
    )
    rmarkdown::render(
        input,
        output_options = list(pandoc_args = lua_filter),
        ...
    )
}


# Addin wrappers -----------------------------------------------------------

#' @keywords internal
create_two_treatment_comparison_mayo <- function() {
    create_two_treatment_comparison(mayo = TRUE)
}

#' @keywords internal
create_two_treatment_two_sex_comparison_mayo <- function() {
    create_two_treatment_two_sex_comparison(mayo = TRUE)
}

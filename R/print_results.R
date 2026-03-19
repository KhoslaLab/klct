#' Print bone microCT data
#'
#' This is a wrapper around [knitr::kable()] to print out bone microCT
#' data at one site by sex for use in an R Markdown document. A code
#' chunk containing this function should probably have the `results = "asis"`
#' option set to allow for pretty formatting.
#'
#' @param data A data frame containing bone microCT data, formatted as is the
#'   output of [read_trabecular()] or [read_cortical()].
#' @param ... Additional arguments passed on to [knitr::kable()].
#'
#' @return Text output which by default is a Pandoc markdown pipe table for each
#'   sex contained in the `data` supplied.
#' @export
#'
#' @examples
#' mouse_table <- read_mouse_table(klct_ex("mouse-table.csv"))
#' spine_trab <- read_trabecular(klct_ex("spine_trabecular_data.csv"),
#'                               mouse_table, site = "Spine")
#' print_data(spine_trab)
print_data <- function(data, ...) {
    sexes <- data$Sex |> unique()

    # Determine which columns to drop (metadata columns that aren't needed)
    drop_cols <- intersect(c("Animal ID", "Site"), names(data))

    for (j in seq_along(sexes)) {
        if ("Treatment" %in% names(data)) {
            print(knitr::kable(data |>
                                   dplyr::filter(Sex == sexes[j]) |>
                                   dplyr::select(-dplyr::all_of(drop_cols)) |>
                                   dplyr::arrange(Treatment),
                               ...))
        } else if ("Genotype" %in% names(data)) {
            print(knitr::kable(data |>
                                   dplyr::filter(Sex == sexes[j]) |>
                                   dplyr::select(-dplyr::all_of(drop_cols)) |>
                                   dplyr::arrange(Genotype),
                               ...))
        }

        cat("\n\n")
    }
}

#' Print bone microCT comparison analysis results
#'
#' This function wraps and extends [knitr::kable()] to format and print the
#' results of bone microCT comparison analyses at one site by sex for use in an
#' R Markdown document. A code chunk containing this function should probably
#' have the `results = "asis"` option to allow pretty formatting. Any `NA`
#' values are printed as an empty string.
#'
#' @param results A list of microCT comparison results, formatted as is the
#'   output of [compare_groups()].
#' @param sig_color What color to print a significant result. Defaults to
#'   `"red"`. Set to `NULL` to disable (and just print everything black).
#' @param ... Additional arguments passed on to [knitr::kable()].
#'
#' @return Text output which is by default a Pandoc markdown pipe table for each
#'   measure and each sex analyzed. If two sexes are analyzed, Pandoc fenced div
#'   syntax is used to print the tables in two columns by sex.
#' @export
#'
#' @examples
#' mouse_table <- read_mouse_table(klct_ex("mouse-table.csv"))
#' spine_trab <- read_trabecular(klct_ex("spine_trabecular_data.csv"),
#'                               mouse_table, site = "Spine")
#' spine_res <- compare_groups(spine_trab)
#' print_results(spine_res)
print_results <- function(results, sig_color = "red", ...) {
    withr::local_options(list(knitr.kable.NA = ""))
    sexes <- names(results[[1]])
    if (length(sexes) == 2) {
        cat(":::: {style=\"display: flex;\"}\n\n")
        for (j in seq_along(sexes)) {
            cat("::: {}\n\n")
            for (i in seq_along(results)) {
                dat <- results[[i]][[sexes[j]]]
                if ((sum(dat$Sig == "") == 2) | is.null(sig_color)) {
                    cat("**", names(results)[i], "**", sep = "")
                } else {
                    cat("[**", names(results)[i], "**]{color=\"",
                        sig_color, "\"}", sep = "")
                }
                print(knitr::kable(dat, ...))
                cat("\n\n")
            }
            cat(":::\n\n")
        }
        cat("::::\n\n")
    } else if (length(sexes) == 1) {
        for (j in seq_along(sexes)) {
            for (i in seq_along(results)) {
                dat <- results[[i]][[sexes[j]]]
                if ((sum(dat$Sig == "") == 2) | is.null(sig_color)) {
                    cat("**", names(results)[i], "**", sep = "")
                } else {
                    cat("[**", names(results)[i], "**]{color=\"",
                        sig_color, "\"}", sep = "")
                }
                print(knitr::kable(dat, ...))
                cat("\n\n")
            }
        }
    } else {
        stop("The number of sexes is not 1 or 2!")
    }
}


#' Print bone microCT two-way comparison results
#'
#' This function formats and prints the results of a two-way (Treatment x Sex)
#' microCT comparison analysis for use in an R Markdown document. Supports
#' output from both parametric (two-way ANOVA) and nonparametric (Aligned Rank
#' Transform ANOVA) analyses. A code chunk containing this function should
#' probably have the `results = "asis"` option to allow pretty formatting.
#'
#' @param results A list of microCT comparison results, formatted as is the
#'   output of [compare_groups_2x2()].
#' @param sig_color What color to print a significant result. Defaults to
#'   `"red"`. Set to `NULL` to disable (and just print everything black).
#' @param ... Additional arguments passed on to [knitr::kable()].
#'
#' @return Text output which is by default Pandoc markdown pipe tables for
#'   each measure, showing both the statistical test results and group-level
#'   summary statistics.
#' @export
#'
#' @examples
#' mouse_table <- read_mouse_table(klct_ex("mouse-table.csv"))
#' spine_trab <- read_trabecular(klct_ex("spine_trabecular_data.csv"),
#'                               mouse_table, site = "Spine")
#' spine_2x2 <- compare_groups_2x2(spine_trab)
#' print_results_2x2(spine_2x2)
print_results_2x2 <- function(results, sig_color = "red", ...) {
    withr::local_options(list(knitr.kable.NA = ""))
    for (i in seq_along(results)) {
        r <- results[[i]]

        # Determine test type and get omnibus table
        if ("anova" %in% names(r)) {
            omnibus_tbl <- r$anova
            omnibus_label <- "*Type III ANOVA*"
            summ_label <- paste0(
                "*Group Summaries (Welch's t-test comparing groups ",
                "within each sex)*"
            )
        } else if ("art_anova" %in% names(r)) {
            omnibus_tbl <- r$art_anova
            omnibus_label <- "*Aligned Rank Transform ANOVA*"
            summ_label <- paste0(
                "*Group Summaries (Wilcoxon comparing groups ",
                "within each sex)*"
            )
        } else {
            stop("Unexpected results format: expected 'anova' or 'art_anova'.")
        }

        # Check significance across omnibus and summary pairwise columns
        any_sig <- any(omnibus_tbl$P < 0.05, na.rm = TRUE) |
            any(r$summary$P < 0.05, na.rm = TRUE)

        if (!any_sig | is.null(sig_color)) {
            cat("**", names(results)[i], "**\n\n", sep = "")
        } else {
            cat("[**", names(results)[i], "**]{color=\"",
                sig_color, "\"}\n\n", sep = "")
        }

        cat(omnibus_label, "\n\n")
        print(knitr::kable(omnibus_tbl, ...))
        cat("\n\n")

        cat(summ_label, "\n\n")
        print(knitr::kable(r$summary, ...))
        cat("\n\n---\n\n")
    }
}

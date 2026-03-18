get_sig <- function(p_value) {
    if (is.na(p_value)) return("")
    if (p_value < 0.001) {
        sig <- "***"
    } else if (p_value < 0.01) {
        sig <- "**"
    } else if (p_value < 0.05) {
        sig <- "*"
    } else {
        sig <- ""
    }
    sig
}


# Default measure sets -----------------------------------------------------

#' Default trabecular measures
#'
#' The subset of trabecular bone parameters reported by default:
#' `Tb.BV/TV`, `Tb.Th`, `Tb.Sp`, and `Tb.N`.
#' @export
default_trabecular_measures <- c("Tb.BV/TV", "Tb.Th", "Tb.Sp", "Tb.N")

#' Default cortical measures
#'
#' The subset of cortical bone parameters reported by default:
#' `Ct.Ar`, `Ma.Ar`, `Tt.Ar`, `Ct.Ar/Tt.Ar`, `Ct.Th`, `Ct.Po`, `Ps.Pm`,
#' `Es.Pm`, and `Ct.vBMD`.
#' @export
default_cortical_measures <- c("Ct.Ar", "Ma.Ar", "Tt.Ar", "Ct.Ar/Tt.Ar", "Ct.Th",
                               "Ct.Po", "Ps.Pm", "Es.Pm",
                               "Ct.vBMD")


# Measure detection helpers ------------------------------------------------

#' Non-measure metadata columns excluded during detection
#' @keywords internal
metadata_cols <- c("AS", "Animal ID", "Sex", "Genotype", "Treatment",
                   "Site", "SampNo", "MeasNo")

#' Detect trabecular measure columns in a data frame
#'
#' Returns all column names that begin with `"Tb."`.
#'
#' @param data A data frame of microCT data.
#' @return A character vector of trabecular measure column names.
#' @keywords internal
detect_trabecular_measures <- function(data) {
    nms <- names(data)
    nms[grepl("^Tb\\.", nms)]
}

#' Detect cortical measure columns in a data frame
#'
#' Returns all numeric column names that are not metadata and do not begin with
#' `"Tb."`. This captures columns prefixed with `Ct.`, `Tt.`, `Po.`, `Ma.`,
#' `Ps.`, `Es.`, and any other scanner-specific numeric outputs.
#'
#' @param data A data frame of microCT data.
#' @return A character vector of cortical measure column names.
#' @keywords internal
detect_cortical_measures <- function(data) {
    nms <- names(data)
    numeric_cols <- nms[vapply(data, is.numeric, logical(1))]
    numeric_cols[!(numeric_cols %in% metadata_cols) &
                     !grepl("^Tb\\.", numeric_cols)]
}


# Measure resolution -------------------------------------------------------

#' Resolve which measures to analyze
#'
#' Given the user-supplied `measures`, `type`, and the data frame, returns the
#' final character vector of column names to analyze.
#'
#' @param data A data frame of microCT data.
#' @param type `"trabecular"`, `"cortical"`, or `NULL`.
#' @param measures `NULL` (use defaults), `"all"` (use every detected column),
#'   or a character vector of specific column names.
#' @return A character vector of measure column names.
#' @keywords internal
.resolve_measures <- function(data, type, measures) {
    # Determine the data type when not supplied
    if (is.null(type)) {
        tb_cols <- detect_trabecular_measures(data)
        ct_cols <- detect_cortical_measures(data)
        has_tb <- length(tb_cols) > 0
        has_ct <- length(ct_cols) > 0

        if (has_tb & !has_ct) {
            type <- "trabecular"
        } else if (has_ct & !has_tb) {
            type <- "cortical"
        } else if (has_tb & has_ct) {
            stop("Data contains both trabecular and cortical columns. ",
                 "Please specify type as \"trabecular\" or \"cortical\".")
        } else {
            stop("Cannot figure out what type of data this is! ",
                 "Please specify type as \"trabecular\" or \"cortical\".")
        }
    }

    # Resolve the measure set
    if (is.null(measures)) {
        # Use sensible defaults, keeping only those present in the data
        if (type == "trabecular") {
            out <- default_trabecular_measures[
                default_trabecular_measures %in% names(data)
            ]
        } else if (type == "cortical") {
            out <- default_cortical_measures[
                default_cortical_measures %in% names(data)
            ]
        } else {
            stop("Type of data must be \"trabecular\" or \"cortical\".")
        }
        if (length(out) == 0) {
            stop("None of the default ", type, " measures were found in ",
                 "the data. Use measures = \"all\" or supply a character ",
                 "vector of column names.")
        }
    } else if (length(measures) == 1 && measures == "all") {
        # Use every detected column of the appropriate type
        if (type == "trabecular") {
            out <- detect_trabecular_measures(data)
        } else if (type == "cortical") {
            out <- detect_cortical_measures(data)
        } else {
            stop("Type of data must be \"trabecular\" or \"cortical\".")
        }
        if (length(out) == 0) {
            stop("No ", type, " measure columns found in the data.")
        }
    } else {
        # User supplied an explicit character vector
        missing <- measures[!(measures %in% names(data))]
        if (length(missing) > 0) {
            stop("The following measures were not found in the data: ",
                 paste(missing, collapse = ", "))
        }
        out <- measures
    }
    out
}


# Analysis functions -------------------------------------------------------

#' Compare microCT data between two treatments
#'
#' This function takes in trabecular or cortical bone microCT data at one site
#' and compares it between two treatments. By default, each sex is compared
#' separately. A parametric (Student's *t*-test) or nonparametric
#' (Wilcoxon rank-sum test) approach can be selected.
#'
#' @param data Bone microCT data in a data frame, formatted as is the output
#'   of [read_trabecular()] or [read_cortical()]. Note that data for only one
#'   Site should be supplied at a time.
#' @param type A string indicating the type of data supplied. Options include
#'   `"trabecular"` or `"cortical"`. Defaults to `NULL`, in which case the
#'   function will try to figure out which type of data it is.
#' @param measures Which bone parameters to analyze. There are three options:
#'
#'   * `NULL` (the default): analyze a sensible subset of commonly reported
#'     parameters. For trabecular data these are stored in
#'     [default_trabecular_measures]; for cortical data, in
#'     [default_cortical_measures].
#'   * `"all"`: analyze every detected parameter of the appropriate type.
#'   * A character vector of specific column names (e.g.,
#'     `c("Tb.BV/TV", "Tb.Th")`).
#' @param test A string indicating which statistical test to use. Options are
#'   `"parametric"` (default) for a Student's *t*-test, or `"nonparametric"`
#'   for a Wilcoxon rank-sum test.
#'
#' @return A list of each bone measure analyzed. Each measure is itself a list
#'   of each sex analyzed. Each sex is a tibble/data frame containing columns
#'   for `Sex`, `Treatment`, `n`, `Mean`, `SEM`, `P`, and `Sig`
#'   (a string containing `"*"` if *P* < 0.05, `"**"` if *P* < 0.01, or
#'   `"***"` if *P* < 0.001). When `test = "nonparametric"`, `Mean` is replaced
#'   by `Median` and `SEM` by `IQR`.
#' @export
#'
#' @examples
#' mouse_table <- read_mouse_table(mctr_ex("CD2MouseTable.csv"))
#' spine_trab <- read_trabecular(mctr_ex("spine_trabecular_data.csv"),
#'                               mouse_table, site = "Spine")
#'
#' # Default measures, parametric
#' spine_res <- compare_groups(spine_trab)
#'
#' # All available trabecular measures
#' spine_all <- compare_groups(spine_trab, measures = "all")
#'
#' # Specific measures, nonparametric
#' spine_custom <- compare_groups(spine_trab,
#'                                measures = c("Tb.BV/TV", "Tb.Th"),
#'                                test = "nonparametric")
compare_groups <- function(data, type = NULL, measures = NULL,
                           test = "parametric") {
    measures <- .resolve_measures(data, type, measures)
    test <- match.arg(test, c("parametric", "nonparametric"))

    if ("Treatment" %in% names(data)) {
        dat <- data |> dplyr::rename(Group = Treatment)
        group_col <- "Treatment"
    } else if ("Genotype" %in% names(data)) {
        dat <- data |> dplyr::rename(Group = Genotype)
        group_col <- "Genotype"
    } else {
        stop("There is no Treatment or Genotype column provided!")
    }

    groups <- if (is.factor(dat$Group)) levels(dat$Group) else unique(dat$Group)
    if (length(groups) != 2) {
        stop("There are not exactly 2 groups!")
    }

    sites <- dat$Site |> unique()
    if (length(sites) != 1) {
        stop("This function expects there to be one Site in the data supplied.")
    }

    sexes <- dat$Sex |> unique()

    res <- vector(mode = "list", length = length(measures))
    names(res) <- measures

    for (m in measures) {
        res_by_sex <- vector(mode = "list", length = length(sexes))
        names(res_by_sex) <- sexes

        for (s in sexes) {
            d <- dat |> dplyr::filter(Sex == s)

            g1 <- d |>
                dplyr::filter(Group == groups[1]) |>
                dplyr::pull(var = m)
            g2 <- d |>
                dplyr::filter(Group == groups[2]) |>
                dplyr::pull(var = m)

            # Remove NAs
            g1 <- g1[!is.na(g1)]
            g2 <- g2[!is.na(g2)]

            if (test == "parametric") {
                if (length(g1) >= 2 && length(g2) >= 2 &&
                    stats::var(g1) > 0 && stats::var(g2) > 0) {
                    if (stats::var.test(g1, g2)$p.value < 0.05) {
                        tt <- stats::t.test(g1, g2)
                    } else {
                        tt <- stats::t.test(g1, g2, var.equal = TRUE)
                    }
                    p_val <- tt$p.value
                } else {
                    p_val <- NA
                }

                sig <- get_sig(p_val)

                r <- dplyr::tibble(
                    Sex = s,
                    Group = groups,
                    n = c(length(g1), length(g2)),
                    Mean = c(mean(g1), mean(g2)),
                    SEM = c(stats::sd(g1) / sqrt(length(g1)),
                            stats::sd(g2) / sqrt(length(g2))),
                    P = c(NA, p_val),
                    Sig = c("", sig)
                )
            } else {
                if (length(g1) >= 1 && length(g2) >= 1) {
                    wt <- stats::wilcox.test(g1, g2, exact = FALSE)
                    p_val <- wt$p.value
                } else {
                    p_val <- NA
                }

                sig <- get_sig(p_val)

                r <- dplyr::tibble(
                    Sex = s,
                    Group = groups,
                    n = c(length(g1), length(g2)),
                    Median = c(stats::median(g1), stats::median(g2)),
                    IQR = c(stats::IQR(g1), stats::IQR(g2)),
                    P = c(NA, p_val),
                    Sig = c("", sig)
                )
            }

            r <- r |> dplyr::rename(!!group_col := Group)
            res_by_sex[[s]] <- r
        }
        res[[m]] <- res_by_sex
    }
    res
}


#' Compare microCT data between two treatments and two sexes
#'
#' This function takes in trabecular or cortical bone microCT data at one site
#' and compares it using a two-way design with Treatment and Sex as factors.
#' A parametric (two-way ANOVA) or nonparametric (Aligned Rank Transform via
#' the [ARTool][ARTool::art] package) approach can be selected.
#'
#' @inheritParams compare_groups
#'
#' @return A list of each bone measure analyzed. Each measure is a list with
#'   two elements:
#'
#'   * An omnibus test table: `anova` (for parametric) or `art_anova` (for
#'     nonparametric), containing columns `Factor`, `P`, and `Sig`.
#'   * `summary`: a tibble of group-level summary statistics with pairwise
#'     comparisons (*t*-test for parametric, Wilcoxon for nonparametric)
#'     merged in. Contains `Sex`, Treatment/Genotype, `n`, `Mean`/`SEM` (or
#'     `Median`/`IQR`), `P`, and `Sig`. Within each sex the first group row
#'     has `P = NA` and `Sig = ""`, and the second group row carries the
#'     pairwise *P*-value and significance stars.
#' @export
#'
#' @examples
#' mouse_table <- read_mouse_table(mctr_ex("CD2MouseTable.csv"))
#' spine_trab <- read_trabecular(mctr_ex("spine_trabecular_data.csv"),
#'                               mouse_table, site = "Spine")
#'
#' # Default measures
#' spine_2x2 <- compare_groups_2x2(spine_trab)
#'
#' # All available trabecular measures
#' spine_2x2_all <- compare_groups_2x2(spine_trab, measures = "all")
compare_groups_2x2 <- function(data, type = NULL, measures = NULL,
                               test = "parametric") {
    measures <- .resolve_measures(data, type, measures)
    test <- match.arg(test, c("parametric", "nonparametric"))

    if ("Treatment" %in% names(data)) {
        group_col <- "Treatment"
    } else if ("Genotype" %in% names(data)) {
        group_col <- "Genotype"
    } else {
        stop("There is no Treatment or Genotype column provided!")
    }

    groups <- data[[group_col]] |> unique()
    if (length(groups) != 2) {
        stop("There are not exactly 2 groups!")
    }

    sexes <- data$Sex |> unique()
    if (length(sexes) != 2) {
        stop("This function expects there to be exactly 2 sexes in the data.")
    }

    sites <- data$Site |> unique()
    if (length(sites) != 1) {
        stop("This function expects there to be one Site in the data supplied.")
    }

    res <- vector(mode = "list", length = length(measures))
    names(res) <- measures

    for (m in measures) {
        d <- data |>
            dplyr::select(AS, Sex, dplyr::all_of(c(group_col, m))) |>
            tidyr::drop_na()

        d$Sex <- factor(d$Sex)
        d[[group_col]] <- factor(d[[group_col]])

        sexes_vec <- levels(d$Sex)
        groups_vec <- levels(d[[group_col]])

        if (test == "parametric") {
            # --- Omnibus: two-way ANOVA, trimmed to Factor/P/Sig ---
            formula_str <- paste0("`", m, "` ~ Sex * `", group_col, "`")
            aov_fit <- stats::aov(stats::as.formula(formula_str), data = d)
            aov_summary <- summary(aov_fit)[[1]]

            # Drop the Residuals row
            n_terms <- nrow(aov_summary) - 1
            omnibus_tbl <- dplyr::tibble(
                Factor = c("Sex", group_col,
                           paste0("Sex:", group_col))[seq_len(n_terms)],
                P = aov_summary[["Pr(>F)"]][seq_len(n_terms)],
                Sig = sapply(
                    aov_summary[["Pr(>F)"]][seq_len(n_terms)], get_sig
                )
            )

            # --- Group summaries with pairwise t-tests ---
            summ_rows <- list()
            for (s in sexes_vec) {
                ds <- d |> dplyr::filter(Sex == s)
                g1 <- ds |>
                    dplyr::filter(.data[[group_col]] == groups_vec[1]) |>
                    dplyr::pull(var = m)
                g2 <- ds |>
                    dplyr::filter(.data[[group_col]] == groups_vec[2]) |>
                    dplyr::pull(var = m)
                g1 <- g1[!is.na(g1)]
                g2 <- g2[!is.na(g2)]

                if (length(g1) >= 2 && length(g2) >= 2 &&
                    stats::var(g1) > 0 && stats::var(g2) > 0) {
                    if (stats::var.test(g1, g2)$p.value < 0.05) {
                        tt <- stats::t.test(g1, g2)
                    } else {
                        tt <- stats::t.test(g1, g2, var.equal = TRUE)
                    }
                    p_val <- tt$p.value
                } else {
                    p_val <- NA
                }

                summ_rows <- c(summ_rows, list(dplyr::tibble(
                    Sex = s,
                    Group = groups_vec,
                    n = c(length(g1), length(g2)),
                    Mean = c(mean(g1), mean(g2)),
                    SEM = c(stats::sd(g1) / sqrt(length(g1)),
                            stats::sd(g2) / sqrt(length(g2))),
                    P = c(NA, p_val),
                    Sig = c("", get_sig(p_val))
                )))
            }
            summ <- dplyr::bind_rows(summ_rows) |>
                dplyr::rename(!!group_col := Group)

            res[[m]] <- list(anova = omnibus_tbl, summary = summ)
        } else {
            # --- Omnibus: ART ANOVA, trimmed to Factor/P/Sig ---
            formula_str <- paste0("`", m, "` ~ Sex * `", group_col, "`")
            art_fit <- ARTool::art(stats::as.formula(formula_str), data = d)
            art_aov <- stats::anova(art_fit)

            omnibus_tbl <- dplyr::tibble(
                Factor = rownames(art_aov),
                P = art_aov[["Pr(>F)"]],
                Sig = sapply(art_aov[["Pr(>F)"]], get_sig)
            )

            # --- Group summaries with pairwise Wilcoxon tests ---
            summ_rows <- list()
            for (s in sexes_vec) {
                ds <- d |> dplyr::filter(Sex == s)
                g1 <- ds |>
                    dplyr::filter(.data[[group_col]] == groups_vec[1]) |>
                    dplyr::pull(var = m)
                g2 <- ds |>
                    dplyr::filter(.data[[group_col]] == groups_vec[2]) |>
                    dplyr::pull(var = m)
                g1 <- g1[!is.na(g1)]
                g2 <- g2[!is.na(g2)]

                if (length(g1) >= 1 && length(g2) >= 1) {
                    wt <- stats::wilcox.test(g1, g2, exact = FALSE)
                    p_val <- wt$p.value
                } else {
                    p_val <- NA
                }

                summ_rows <- c(summ_rows, list(dplyr::tibble(
                    Sex = s,
                    Group = groups_vec,
                    n = c(length(g1), length(g2)),
                    Median = c(stats::median(g1), stats::median(g2)),
                    IQR = c(stats::IQR(g1), stats::IQR(g2)),
                    P = c(NA, p_val),
                    Sig = c("", get_sig(p_val))
                )))
            }
            summ <- dplyr::bind_rows(summ_rows) |>
                dplyr::rename(!!group_col := Group)

            res[[m]] <- list(art_anova = omnibus_tbl, summary = summ)
        }
    }
    res
}

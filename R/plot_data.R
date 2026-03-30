#' Plot bone microCT data by treatment
#'
#' This function takes in bone microCT data and produces boxplots comparing two
#' treatments. Each sex is plotted separately.
#'
#' If the two treatments are significantly different, statistical significance
#' will be indicated with a bracket and `"*"` if *P* < 0.05, `"**"` if
#' *P* < 0.01, or `"***"` if *P* < 0.001.
#'
#' @param data A tibble/data frame containing bone microCT data, formatted as is
#'   the output of [read_trabecular()] or [read_cortical()].
#' @param type A string indicating the type of data supplied. Options include
#'   `"trabecular"` or `"cortical"`. Defaults to `NULL`, in which case the
#'   function will try to figure out which type of data it is.
#' @param measures Which bone parameters to plot. There are three options:
#'   * `NULL` (the default): plot the sensible subset of commonly reported
#'     parameters defined in [default_trabecular_measures] or
#'     [default_cortical_measures].
#'   * `"all"`: plot every detected parameter of the appropriate type.
#'   * A character vector of specific column names (e.g.,
#'     `c("Ct.Ar", "Ct.Th")`).
#' @param test A string indicating which statistical test to use for
#'   significance annotations. Options are `"parametric"` (default) for
#'   Welch's *t*-test, or `"nonparametric"` for a Wilcoxon rank-sum test.
#' @param title A string indicating what type of title the plots should have.
#'   Defaults to `"sex"`, which is currently the only option implemented. To
#'   remove titles from the plots, set `title` to `NULL`.
#' @param x_axis_angle The angle at which to rotate the x-axis labels so they
#'   don't overlap, passed on to [ggplot2::theme()] as
#'   `axis.text.x = element_text(angle = x_axis_angle)`.
#'
#' @return A list containing [ggplot2::ggplot()] objects for each sex analyzed.
#'   To print each plot without printing the list index, see [print_plots()].
#' @export
#'
#' @examples
#' mouse_table <- read_mouse_table(klct_ex("mouse-table.csv"))
#' met_cort <- read_cortical(klct_ex("femur_metaphysis_data.csv"),
#'                           mouse_table, site = "Met")
#'
#' # Default measures
#' plot_groups(met_cort) |> print_plots()
#'
#' # All cortical measures
#' plot_groups(met_cort, measures = "all") |> print_plots()
#'
#' # Specific measures, nonparametric
#' plot_groups(met_cort, measures = c("Ct.Th", "Ct.vBMD"),
#'             test = "nonparametric") |> print_plots()
plot_groups <- function(data, type = NULL, measures = NULL,
                        test = "parametric", title = "sex",
                        x_axis_angle = 45) {
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

    sexes <- data$Sex |> unique()
    annot_by_sex <- vector(mode = "list", length = length(sexes))
    plot_by_sex <- vector(mode = "list", length = length(sexes))
    names(annot_by_sex) <- names(plot_by_sex) <- sexes

    for (s in sexes) {
        d <- dat |> dplyr::filter(Sex == s)
        annot <- dplyr::tibble(
            Measure = factor(character(), levels = measures),
            label = character(),
            y_position = double()
        )

        for (m in measures) {
            g1 <- d |>
                dplyr::filter(Group == groups[1]) |>
                dplyr::pull(var = m)
            g2 <- d |>
                dplyr::filter(Group == groups[2]) |>
                dplyr::pull(var = m)

            g1 <- g1[!is.na(g1)]
            g2 <- g2[!is.na(g2)]

            if (test == "parametric") {
                # Always use Welch's t-test (no preliminary F-test)
                if (length(g1) >= 2 && length(g2) >= 2 &&
                    stats::var(g1) > 0 && stats::var(g2) > 0) {
                    tt <- stats::t.test(g1, g2)
                    p_val <- tt$p.value
                } else {
                    p_val <- NA
                }
            } else {
                if (length(g1) >= 1 && length(g2) >= 1) {
                    wt <- stats::wilcox.test(g1, g2, exact = FALSE)
                    p_val <- wt$p.value
                } else {
                    p_val <- NA
                }
            }

            sig <- get_sig(p_val)

            if (nchar(sig) > 0) {
                all_vals <- c(g1, g2)
                y_max <- max(all_vals, na.rm = TRUE)
                y_range <- diff(range(all_vals, na.rm = TRUE))
                # Place bracket just above the highest data point
                annot <- dplyr::bind_rows(annot, dplyr::tibble(
                    Measure = factor(m, levels = measures),
                    label = sig,
                    y_position = y_max + 0.05 * y_range
                ))
            }
        }
        annot_by_sex[[s]] <- annot
    }

    # Build a named vector for facet strip labels with units.
    # Use multiline so the unit wraps below the measure name in narrow facets.
    facet_labels <- stats::setNames(
        get_measure_label(measures, multiline = TRUE), measures
    )

    for (s in sexes) {
        plot_dat <- data |>
            dplyr::filter(Sex == s) |>
            tidyr::pivot_longer(cols = dplyr::all_of(measures),
                                names_to = "Measure",
                                values_to = "Value")

        p <- plot_dat |>
            ggplot2::ggplot(ggplot2::aes(x = .data[[group_col]], y = Value))

        n_facet_cols <- min(length(measures), 5)

        p <- p +
            ggplot2::facet_wrap(
                ggplot2::vars(factor(Measure, levels = measures)),
                scales = "free_y",
                ncol = n_facet_cols,
                labeller = ggplot2::as_labeller(facet_labels)
            ) +
            ggplot2::geom_boxplot() +
            ggplot2::geom_point(position = ggplot2::position_jitter(width = 0.2)) +
            ggplot2::ylab(NULL) +
            ggplot2::theme(axis.text.x = ggplot2::element_text(
                angle = x_axis_angle, vjust = 0.5, hjust = 0.5
            ))

        if (nrow(annot_by_sex[[s]]) > 0) {
            p <- p +
                ggsignif::geom_signif(
                    data = annot_by_sex[[s]],
                    ggplot2::aes(
                        xmin = 1,
                        xmax = 2,
                        annotations = label,
                        y_position = y_position
                    ),
                    manual = TRUE,
                    textsize = 5,
                    vjust = -0.2,
                    inherit.aes = FALSE
                )
        }

        if (!is.null(title)) {
            if (title == "sex") {
                p <- p + ggplot2::ggtitle(paste("Sex:", s))
            }
        }

        plot_by_sex[[s]] <- p
    }
    plot_by_sex
}


#' Plot bone microCT data by treatment and sex
#'
#' This function takes in bone microCT data and produces boxplots comparing
#' two treatments, with sex displayed on the x-axis and treatments
#' distinguished by color/fill.
#'
#' @inheritParams plot_groups
#'
#' @return A list containing [ggplot2::ggplot()] objects, one per measure.
#'   To print each plot without printing the list index, see [print_plots()].
#' @export
#'
#' @examples
#' mouse_table <- read_mouse_table(klct_ex("mouse-table.csv"))
#' spine_trab <- read_trabecular(klct_ex("spine_trabecular_data.csv"),
#'                               mouse_table, site = "Spine")
#'
#' # Default measures
#' plot_groups_2x2(spine_trab) |> print_plots()
#'
#' # All available trabecular measures
#' plot_groups_2x2(spine_trab, measures = "all") |> print_plots()
plot_groups_2x2 <- function(data, type = NULL, measures = NULL,
                            x_axis_angle = 0) {
    measures <- .resolve_measures(data, type, measures)

    if ("Treatment" %in% names(data)) {
        group_col <- "Treatment"
    } else if ("Genotype" %in% names(data)) {
        group_col <- "Genotype"
    } else {
        stop("There is no Treatment or Genotype column provided!")
    }

    plot_list <- vector(mode = "list", length = length(measures))
    names(plot_list) <- measures

    for (m in measures) {
        p <- data |>
            ggplot2::ggplot(
                ggplot2::aes(x = Sex, y = .data[[m]],
                             fill = .data[[group_col]])
            ) +
            ggplot2::geom_boxplot(position = ggplot2::position_dodge(0.8)) +
            ggplot2::geom_point(
                position = ggplot2::position_jitterdodge(
                    jitter.width = 0.2, dodge.width = 0.8
                )
            ) +
            ggplot2::ggtitle(m) +
            ggplot2::ylab(get_measure_label(m)) +
            ggplot2::theme(axis.text.x = ggplot2::element_text(
                angle = x_axis_angle, vjust = 0.5, hjust = 0.5
            ))

        plot_list[[m]] <- p
    }
    plot_list
}


#' Print a list of plots
#'
#' This function iterates through a list of plots and prints them (without
#' printing the list index).
#'
#' @param plots A list of [ggplot2::ggplot()] objects.
#'
#' @return Returns NULL, since this function is used for its side effects.
#' @export
#'
#' @examples
#' mouse_table <- read_mouse_table(klct_ex("mouse-table.csv"))
#' met_cort <- read_cortical(klct_ex("femur_metaphysis_data.csv"),
#'                           mouse_table, site = "Met")
#' plot_groups(met_cort) |> print_plots()
print_plots <- function(plots) {
    for (p in plots) {
        print(p)
    }
}

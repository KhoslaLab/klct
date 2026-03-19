# Plot bone microCT data by treatment

This function takes in bone microCT data and produces boxplots comparing
two treatments. Each sex is plotted separately.

## Usage

``` r
plot_groups(
  data,
  type = NULL,
  measures = NULL,
  test = "parametric",
  title = "sex",
  x_axis_angle = 45
)
```

## Arguments

- data:

  A tibble/data frame containing bone microCT data, formatted as is the
  output of
  [`read_trabecular()`](https://khoslalab.github.io/klct/reference/read_trabecular.md)
  or
  [`read_cortical()`](https://khoslalab.github.io/klct/reference/read_cortical.md).

- type:

  A string indicating the type of data supplied. Options include
  `"trabecular"` or `"cortical"`. Defaults to `NULL`, in which case the
  function will try to figure out which type of data it is.

- measures:

  Which bone parameters to plot. There are three options:

  - `NULL` (the default): plot the sensible subset of commonly reported
    parameters defined in
    [default_trabecular_measures](https://khoslalab.github.io/klct/reference/default_trabecular_measures.md)
    or
    [default_cortical_measures](https://khoslalab.github.io/klct/reference/default_cortical_measures.md).

  - `"all"`: plot every detected parameter of the appropriate type.

  - A character vector of specific column names (e.g.,
    `c("Ct.Ar", "Ct.Th")`).

- test:

  A string indicating which statistical test to use for significance
  annotations. Options are `"parametric"` (default) for Welch's
  *t*-test, or `"nonparametric"` for a Wilcoxon rank-sum test.

- title:

  A string indicating what type of title the plots should have. Defaults
  to `"sex"`, which is currently the only option implemented. To remove
  titles from the plots, set `title` to `NULL`.

- x_axis_angle:

  The angle at which to rotate the x-axis labels so they don't overlap,
  passed on to
  [`ggplot2::theme()`](https://ggplot2.tidyverse.org/reference/theme.html)
  as `axis.text.x = element_text(angle = x_axis_angle)`.

## Value

A list containing
[`ggplot2::ggplot()`](https://ggplot2.tidyverse.org/reference/ggplot.html)
objects for each sex analyzed. To print each plot without printing the
list index, see
[`print_plots()`](https://khoslalab.github.io/klct/reference/print_plots.md).

## Details

If the two treatments are significantly different, statistical
significance will be indicated with `"*"` if *P* \< 0.05, `"**"` if *P*
\< 0.01, or `"***"` if *P* \< 0.001.

## Examples

``` r
mouse_table <- read_mouse_table(klct_ex("mouse-table.csv"))
met_cort <- read_cortical(klct_ex("femur_metaphysis_data.csv"),
                          mouse_table, site = "Met")

# Default measures
plot_groups(met_cort) |> print_plots()



# All cortical measures
plot_groups(met_cort, measures = "all") |> print_plots()



# Specific measures, nonparametric
plot_groups(met_cort, measures = c("Ct.Th", "Ct.vBMD"),
            test = "nonparametric") |> print_plots()

```

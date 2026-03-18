# Plot bone microCT data by treatment and sex

This function takes in bone microCT data and produces boxplots comparing
two treatments, with sex displayed on the x-axis and treatments
distinguished by color/fill.

## Usage

``` r
plot_groups_2x2(data, type = NULL, measures = NULL, x_axis_angle = 0)
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

- x_axis_angle:

  The angle at which to rotate the x-axis labels so they don't overlap,
  passed on to
  [`ggplot2::theme()`](https://ggplot2.tidyverse.org/reference/theme.html)
  as `axis.text.x = element_text(angle = x_axis_angle)`.

## Value

A list containing
[`ggplot2::ggplot()`](https://ggplot2.tidyverse.org/reference/ggplot.html)
objects, one per measure. To print each plot without printing the list
index, see
[`print_plots()`](https://khoslalab.github.io/klct/reference/print_plots.md).

## Examples

``` r
mouse_table <- read_mouse_table(klct_ex("mouse-table.csv"))
spine_trab <- read_trabecular(klct_ex("spine_trabecular_data.csv"),
                              mouse_table, site = "Spine")

# Default measures
plot_groups_2x2(spine_trab) |> print_plots()





# All available trabecular measures
plot_groups_2x2(spine_trab, measures = "all") |> print_plots()







```

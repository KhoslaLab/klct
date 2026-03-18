# Print a list of plots

This function iterates through a list of plots and prints them (without
printing the list index).

## Usage

``` r
print_plots(plots)
```

## Arguments

- plots:

  A list of
  [`ggplot2::ggplot()`](https://ggplot2.tidyverse.org/reference/ggplot.html)
  objects.

## Value

Returns NULL, since this function is used for its side effects.

## Examples

``` r
mouse_table <- read_mouse_table(klct_ex("mouse-table.csv"))
met_cort <- read_cortical(klct_ex("femur_metaphysis_data.csv"),
                          mouse_table, site = "Met")
plot_groups(met_cort) |> print_plots()

```

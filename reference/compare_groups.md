# Compare microCT data between two treatments

This function takes in trabecular or cortical bone microCT data at one
site and compares it between two treatments. By default, each sex is
compared separately. A parametric (Student's *t*-test) or nonparametric
(Wilcoxon rank-sum test) approach can be selected.

## Usage

``` r
compare_groups(data, type = NULL, measures = NULL, test = "parametric")
```

## Arguments

- data:

  Bone microCT data in a data frame, formatted as is the output of
  [`read_trabecular()`](https://khoslalab.github.io/klct/reference/read_trabecular.md)
  or
  [`read_cortical()`](https://khoslalab.github.io/klct/reference/read_cortical.md).
  Note that data for only one Site should be supplied at a time.

- type:

  A string indicating the type of data supplied. Options include
  `"trabecular"` or `"cortical"`. Defaults to `NULL`, in which case the
  function will try to figure out which type of data it is.

- measures:

  Which bone parameters to analyze. There are three options:

  - `NULL` (the default): analyze a sensible subset of commonly reported
    parameters. For trabecular data these are stored in
    [default_trabecular_measures](https://khoslalab.github.io/klct/reference/default_trabecular_measures.md);
    for cortical data, in
    [default_cortical_measures](https://khoslalab.github.io/klct/reference/default_cortical_measures.md).

  - `"all"`: analyze every detected parameter of the appropriate type.

  - A character vector of specific column names (e.g.,
    `c("Tb.BV/TV", "Tb.Th")`).

- test:

  A string indicating which statistical test to use. Options are
  `"parametric"` (default) for a Student's *t*-test, or
  `"nonparametric"` for a Wilcoxon rank-sum test.

## Value

A list of each bone measure analyzed. Each measure is itself a list of
each sex analyzed. Each sex is a tibble/data frame containing columns
for `Sex`, `Treatment`, `n`, `Mean`, `SEM`, `P`, and `Sig` (a string
containing `"*"` if *P* \< 0.05, `"**"` if *P* \< 0.01, or `"***"` if
*P* \< 0.001). When `test = "nonparametric"`, `Mean` is replaced by
`Median` and `SEM` by `IQR`.

## Examples

``` r
mouse_table <- read_mouse_table(klct_ex("mouse-table.csv"))
spine_trab <- read_trabecular(klct_ex("spine_trabecular_data.csv"),
                              mouse_table, site = "Spine")

# Default measures, parametric
spine_res <- compare_groups(spine_trab)

# All available trabecular measures
spine_all <- compare_groups(spine_trab, measures = "all")

# Specific measures, nonparametric
spine_custom <- compare_groups(spine_trab,
                               measures = c("Tb.BV/TV", "Tb.Th"),
                               test = "nonparametric")
```

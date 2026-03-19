# Compare microCT data between two treatments

This function takes in trabecular or cortical bone microCT data at one
site and compares it between two treatments. By default, each sex is
compared separately. A parametric (Welch's *t*-test) or nonparametric
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
  `"parametric"` (default) for Welch's *t*-test, or `"nonparametric"`
  for a Wilcoxon rank-sum test.

## Value

A list of each bone measure analyzed. Each measure is itself a list of
each sex analyzed. Each sex is a tibble/data frame containing columns
for `Sex`, `Treatment`, `n`, and summary/test statistics.

When `test = "parametric"`, the columns include `Mean`, `SD`, `SEM`,
`Diff`, `CI.Low`, `CI.High`, `Pct.Change`, `P`, `P.adj`, and `Sig`. When
`test = "nonparametric"`, the columns include `Median`, `Q1`, `Q3`,
`Diff`, `CI.Low`, `CI.High`, `Pct.Change`, `P`, `P.adj`, and `Sig`.

`Diff` is the difference (group 2 minus group 1): the difference in
means for parametric, or the Hodges–Lehmann estimate of the location
shift for nonparametric. `CI.Low` and `CI.High` are the 95% confidence
interval bounds for that difference. `Pct.Change` is the percent change
of the second group relative to the first. `P.adj` is the
Benjamini–Hochberg-adjusted *p*-value across all measures within each
sex. `Sig` is based on the raw (unadjusted) *p*-value: `"*"` if *P* \<
0.05, `"**"` if *P* \< 0.01, `"***"` if *P* \< 0.001.

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

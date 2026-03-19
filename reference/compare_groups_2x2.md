# Compare microCT data between two treatments and two sexes

This function takes in trabecular or cortical bone microCT data at one
site and compares it using a two-way design with Treatment and Sex as
factors. A parametric (two-way ANOVA via
[`car::Anova()`](https://rdrr.io/pkg/car/man/Anova.html) with Type III
sums of squares) or nonparametric (Aligned Rank Transform via the
[ARTool](https://rdrr.io/pkg/ARTool/man/art.html) package) approach can
be selected.

## Usage

``` r
compare_groups_2x2(data, type = NULL, measures = NULL, test = "parametric")
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

A list of each bone measure analyzed. Each measure is a list with two
elements:

- An omnibus test table: `anova` (for parametric) or `art_anova` (for
  nonparametric), containing columns `Factor`, `P`, `P.adj`, and `Sig`.
  `P.adj` is Benjamini–Hochberg-adjusted per factor across all measures.

- `summary`: a tibble of group-level summary statistics with pairwise
  comparisons (Welch's *t*-test for parametric, Wilcoxon for
  nonparametric) merged in. Contains `Sex`, Treatment/Genotype, `n`,
  `Mean`/`SD`/`SEM` (or `Median`/`Q1`/`Q3`), `Diff`, `CI.Low`,
  `CI.High`, `Pct.Change`, `P`, `P.adj`, and `Sig`. Within each sex the
  first group row has `P = NA` and `Sig = ""`, and the second group row
  carries the pairwise *P*-value and significance stars (based on raw
  *P*).

## Examples

``` r
mouse_table <- read_mouse_table(klct_ex("mouse-table.csv"))
spine_trab <- read_trabecular(klct_ex("spine_trabecular_data.csv"),
                              mouse_table, site = "Spine")

# Default measures
spine_2x2 <- compare_groups_2x2(spine_trab)

# All available trabecular measures
spine_2x2_all <- compare_groups_2x2(spine_trab, measures = "all")
```

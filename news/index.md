# Changelog

## klct 0.2.0

### Statistical method improvements

- **Welch’s *t*-test by default**: All parametric pairwise comparisons
  now always use Welch’s *t*-test (unequal variances assumed). The
  preliminary *F*-test for equal variances
  ([`var.test()`](https://rdrr.io/r/stats/var.test.html)) has been
  removed, as it inflates Type I error rates. This affects
  [`compare_groups()`](https://khoslalab.github.io/klct/reference/compare_groups.md),
  [`compare_groups_2x2()`](https://khoslalab.github.io/klct/reference/compare_groups_2x2.md),
  and
  [`plot_groups()`](https://khoslalab.github.io/klct/reference/plot_groups.md).

- **Type III sums of squares**:
  [`compare_groups_2x2()`](https://khoslalab.github.io/klct/reference/compare_groups_2x2.md)
  now uses [`lm()`](https://rdrr.io/r/stats/lm.html) +
  `car::Anova(type = "III")` with sum-to-zero contrasts instead of
  [`stats::aov()`](https://rdrr.io/r/stats/aov.html) (which uses Type I
  sequential SS). This gives correct tests for main effects and
  interactions with unbalanced designs.

- **Benjamini–Hochberg adjusted *p*-values**: A `P.adj` column is now
  included in all results tables. In
  [`compare_groups()`](https://khoslalab.github.io/klct/reference/compare_groups.md),
  pairwise *p*-values are BH-adjusted per sex across all measures at a
  site. In
  [`compare_groups_2x2()`](https://khoslalab.github.io/klct/reference/compare_groups_2x2.md),
  omnibus *p*-values are BH-adjusted per factor across measures, and
  pairwise *p*-values are BH-adjusted per sex across measures.
  Significance stars (`Sig`) and red-color highlighting in the R
  Markdown templates continue to be based on the raw (unadjusted)
  *p*-value, as the report is intended for exploratory screening.

### New output columns

- **Difference column**: A `Diff` column shows the raw difference (group
  2 minus group 1). For parametric results this is the difference in
  means; for nonparametric results, the Hodges–Lehmann pseudomedian of
  pairwise differences (from `wilcox.test(conf.int = TRUE)`).

- **95% confidence intervals**: `CI.Low` and `CI.High` columns report
  the 95% CI bounds for the difference. For parametric comparisons these
  come from Welch’s *t*-test. For nonparametric comparisons these come
  from the Wilcoxon rank-sum test with `conf.int = TRUE`.

- **Effect size reporting**: A `Pct.Change` column shows the percent
  change of the second group relative to the first. For parametric
  results this is based on group means; for nonparametric results, on
  group medians.

- **SD column**: Parametric results now include an `SD` column alongside
  the existing `SEM` column.

- **Q1 and Q3 columns**: Nonparametric results now report `Q1` (25th
  percentile) and `Q3` (75th percentile) instead of `IQR`, giving a
  clearer picture of the distribution’s location and spread.

### Dependencies

- Added `car` to Imports (for
  [`car::Anova()`](https://rdrr.io/pkg/car/man/Anova.html) with Type III
  sums of squares).

### Template changes

- The omnibus test label in
  [`print_results_2x2()`](https://khoslalab.github.io/klct/reference/print_results_2x2.md)
  now reads “Type III ANOVA” (parametric) and the pairwise label reads
  “Welch’s t-test” to reflect the updated methods.
- R Markdown templates no longer require all three data files (spine,
  metaphysis, diaphysis) to be present. When a data file is missing, the
  corresponding section is omitted from the report entirely rather than
  causing the report to error. Only the mouse table is required.
- The `knit:` function reference in standard (non-Mayo) templates has
  been corrected from `microctr::knit_with_colored_text` to
  [`klct::knit_with_colored_text`](https://khoslalab.github.io/klct/reference/knit_with_colored_text.md).

## klct 0.1.0

- This is the first functional release of klct, containing the ability
  to analyze NeoScan microCT data comparing two treatment groups.
- Sites analyzed include femoral metaphysis (trabecular and cortical),
  femoral diaphysis (cortical), and lumbar vertebra (trabecular).
- Supports both parametric and nonparametric statistical tests via the
  `test` parameter (`"parametric"` or `"nonparametric"`):
  - Two-treatment comparisons
    ([`compare_groups()`](https://khoslalab.github.io/klct/reference/compare_groups.md)):
    Student’s *t*-test or Wilcoxon rank-sum test.
  - Two-way Treatment × Sex comparisons
    ([`compare_groups_2x2()`](https://khoslalab.github.io/klct/reference/compare_groups_2x2.md)):
    two-way ANOVA or Aligned Rank Transform via
    [`ARTool::art()`](https://rdrr.io/pkg/ARTool/man/art.html).
- Dynamic measure detection:
  [`detect_trabecular_measures()`](https://khoslalab.github.io/klct/reference/detect_trabecular_measures.md)
  matches `^Tb.` columns;
  [`detect_cortical_measures()`](https://khoslalab.github.io/klct/reference/detect_cortical_measures.md)
  captures all other numeric non-metadata columns. A shared internal
  helper
  [`.resolve_measures()`](https://khoslalab.github.io/klct/reference/dot-resolve_measures.md)
  centralizes measure resolution across all analysis and plotting
  functions.
- The `measures` parameter (available in
  [`compare_groups()`](https://khoslalab.github.io/klct/reference/compare_groups.md),
  [`compare_groups_2x2()`](https://khoslalab.github.io/klct/reference/compare_groups_2x2.md),
  and
  [`plot_groups()`](https://khoslalab.github.io/klct/reference/plot_groups.md))
  accepts `NULL` for sensible defaults, `"all"` for all detected
  columns, or a custom character vector. `default_trabecular_measures`
  and `default_cortical_measures` are exported.
- Omnibus tables in two-way results are trimmed to `Factor`, `P`, and
  `Sig` columns only.
- Pairwise comparisons are merged directly into the Group Summaries
  table (blank for the first group, *p*-value and significance stars for
  the second group within each sex), matching the
  [`compare_groups()`](https://khoslalab.github.io/klct/reference/compare_groups.md)
  convention. The table heading reflects the test used (*t*-test or
  Wilcoxon).
- Includes four R Markdown templates:
  - “Compare Two Treatments” for analyzing each sex separately.
  - “Compare Two Treatments (Mayo)” — Mayo-themed version using
    [`mayodown::mayohtml`](https://rdrr.io/pkg/mayodown/man/mayohtml.html).
  - “Compare Two Treatments and Two Sexes” for a full two-way design.
  - “Compare Two Treatments and Two Sexes (Mayo)” — Mayo-themed version
    using
    [`mayodown::mayohtml`](https://rdrr.io/pkg/mayodown/man/mayohtml.html).
- Template features:
  - Parametric and nonparametric results are displayed as separate tabs.
  - By-sex plot tabs are consolidated into a single tab (differing only
    in significance annotations).
  - Combined Sexes Plots tabs are included in all sections.
  - All templates accept a `test` parameter in the YAML header.
- Mayo-themed templates use the `mayodown` package for consistent
  branding, including the Mayo logo, color scheme, and copyright footer.
- The `color-text.lua` Pandoc filter is provided by `mayodown`, enabling
  colored significance annotations in all template formats.

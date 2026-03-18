# Changelog

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


<!-- README.md is generated from README.Rmd. Please edit that file -->

# klct

<!-- badges: start -->

<!-- badges: end -->

This package contains functions to read in and analyze microCT data from
a NeoScan scanner as currently performed in the Khosla Lab. Sites
analyzed include femoral metaphysis, femoral diaphysis, and lumbar
vertebra. Analyses include trabecular bone parameters and cortical bone
parameters.

Both parametric (*t*-test, two-way ANOVA) and nonparametric (Wilcoxon
rank-sum, Aligned Rank Transform via `ARTool`) tests are supported.
Comparisons can be made between two treatments (with each sex analyzed
separately), or between two treatments and two sexes in a full two-way
design.

Measures are detected dynamically from the data, and the `measures`
parameter lets you analyze sensible defaults (`NULL`), all detected
columns (`"all"`), or a custom set of column names.

Mayo-themed R Markdown templates are available via the
[mayodown](https://github.com/KhoslaLab/mayodown) package.

## Installation

You can install the development version of klct from
[GitHub](https://github.com/KhoslaLab/klct) with:

``` r
# install.packages("remotes")
remotes::install_github("KhoslaLab/klct")
```

## Example

``` r
library(klct)

mouse_table <- read_mouse_table(klct_ex("mouse-table.csv"))

spine_trab <- read_trabecular(klct_ex("spine_trabecular_data.csv"),
                              mouse_table, site = "Spine")

# Parametric comparison (default)
Spine.Tb <- compare_groups(spine_trab)

# Nonparametric comparison
Spine.Tb_np <- compare_groups(spine_trab, test = "nonparametric")

# All available trabecular measures
Spine.Tb_all <- compare_groups(spine_trab, measures = "all")

# Two-way (Treatment x Sex) comparison
Spine.Tb_2x2 <- compare_groups_2x2(spine_trab)
```

``` r
print_results(Spine.Tb)
```

<div style="display: flex;">

<div>

**Tb.BV/TV**

| Sex | Treatment |   n |     Mean |      SEM |         P | Sig |
|:----|:----------|----:|---------:|---------:|----------:|:----|
| F   | AP        |  16 | 12.88106 | 1.146596 |           |     |
| F   | Vehicle   |  16 | 12.50113 | 1.297131 | 0.8277794 |     |

**Tb.Th**

| Sex | Treatment |   n |      Mean |       SEM |         P | Sig |
|:----|:----------|----:|----------:|----------:|----------:|:----|
| F   | AP        |  16 | 0.0447956 | 0.0016231 |           |     |
| F   | Vehicle   |  16 | 0.0425694 | 0.0011804 | 0.2761197 |     |

**Tb.Sp**

| Sex | Treatment |   n |      Mean |       SEM |         P | Sig |
|:----|:----------|----:|----------:|----------:|----------:|:----|
| F   | AP        |  16 | 0.3847250 | 0.0188278 |           |     |
| F   | Vehicle   |  16 | 0.3845125 | 0.0177639 | 0.9935043 |     |

**Tb.N**

| Sex | Treatment |   n |     Mean |       SEM |         P | Sig |
|:----|:----------|----:|---------:|----------:|----------:|:----|
| F   | AP        |  16 | 2.415563 | 0.1302996 |           |     |
| F   | Vehicle   |  16 | 2.402875 | 0.1007043 | 0.9391004 |     |

</div>

<div>

**Tb.BV/TV**

| Sex | Treatment |   n |     Mean |       SEM |         P | Sig |
|:----|:----------|----:|---------:|----------:|----------:|:----|
| M   | AP        |  20 | 11.14910 | 0.6919313 |           |     |
| M   | Vehicle   |  16 | 11.96687 | 0.5408511 | 0.3769105 |     |

**Tb.Th**

| Sex | Treatment |   n |      Mean |       SEM |         P | Sig |
|:----|:----------|----:|----------:|----------:|----------:|:----|
| M   | AP        |  20 | 0.0386190 | 0.0008305 |           |     |
| M   | Vehicle   |  16 | 0.0393938 | 0.0015310 | 0.6605264 |     |

**Tb.Sp**

| Sex | Treatment |   n |      Mean |       SEM |         P | Sig |
|:----|:----------|----:|----------:|----------:|----------:|:----|
| M   | AP        |  20 | 0.2945500 | 0.0111613 |           |     |
| M   | Vehicle   |  16 | 0.2867875 | 0.0112278 | 0.6311705 |     |

**Tb.N**

| Sex | Treatment |   n |     Mean |       SEM |         P | Sig |
|:----|:----------|----:|---------:|----------:|----------:|:----|
| M   | AP        |  20 | 3.056250 | 0.0872782 |           |     |
| M   | Vehicle   |  16 | 3.119937 | 0.0984439 | 0.6310858 |     |

</div>

</div>

## Templates

Four R Markdown templates are available from the RStudio template menu
(`File > New File > R Markdown > From Template`), via RStudio Addins
(`Addins > klct`) or via helper functions:

``` r
# Standard templates
create_two_treatment_comparison()
create_two_treatment_two_sex_comparison()

# Mayo-themed templates (uses mayodown::mayohtml)
create_two_treatment_comparison(mayo = TRUE)
create_two_treatment_two_sex_comparison(mayo = TRUE)
```

Parametric and nonparametric results are displayed as separate tabs
within each section, and Combined Sexes Plots tabs are included in all
sections.

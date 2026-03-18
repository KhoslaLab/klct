# Print bone microCT two-way comparison results

This function formats and prints the results of a two-way (Treatment x
Sex) microCT comparison analysis for use in an R Markdown document.
Supports output from both parametric (two-way ANOVA) and nonparametric
(Aligned Rank Transform ANOVA) analyses. A code chunk containing this
function should probably have the `results = "asis"` option to allow
pretty formatting.

## Usage

``` r
print_results_2x2(results, sig_color = "red", ...)
```

## Arguments

- results:

  A list of microCT comparison results, formatted as is the output of
  [`compare_groups_2x2()`](https://khoslalab.github.io/klct/reference/compare_groups_2x2.md).

- sig_color:

  What color to print a significant result. Defaults to `"red"`. Set to
  `NULL` to disable (and just print everything black).

- ...:

  Additional arguments passed on to
  [`knitr::kable()`](https://rdrr.io/pkg/knitr/man/kable.html).

## Value

Text output which is by default Pandoc markdown pipe tables for each
measure, showing both the statistical test results and group-level
summary statistics.

## Examples

``` r
mouse_table <- read_mouse_table(klct_ex("mouse-table.csv"))
spine_trab <- read_trabecular(klct_ex("spine_trabecular_data.csv"),
                              mouse_table, site = "Spine")
spine_2x2 <- compare_groups_2x2(spine_trab)
print_results_2x2(spine_2x2)
#> **Tb.BV/TV**
#> 
#> *Two-Way ANOVA* 
#> 
#> 
#> 
#> |Factor        |         P|Sig |
#> |:-------------|---------:|:---|
#> |Sex           | 0.2176494|    |
#> |Treatment     | 0.7925019|    |
#> |Sex:Treatment | 0.5304139|    |
#> 
#> 
#> *Group Summaries (t-test comparing groups within each sex)* 
#> 
#> 
#> 
#> |Sex |Treatment |  n|     Mean|       SEM|         P|Sig |
#> |:---|:---------|--:|--------:|---------:|---------:|:---|
#> |F   |AP        | 16| 12.88106| 1.1465960|          |    |
#> |F   |Vehicle   | 16| 12.50113| 1.2971308| 0.8277794|    |
#> |M   |AP        | 20| 11.14910| 0.6919313|          |    |
#> |M   |Vehicle   | 16| 11.96687| 0.5408511| 0.3769105|    |
#> 
#> 
#> ---
#> 
#> [**Tb.Th**]{color="red"}
#> 
#> *Two-Way ANOVA* 
#> 
#> 
#> 
#> |Factor        |         P|Sig |
#> |:-------------|---------:|:---|
#> |Sex           | 0.0004938|*** |
#> |Treatment     | 0.6171042|    |
#> |Sex:Treatment | 0.2487624|    |
#> 
#> 
#> *Group Summaries (t-test comparing groups within each sex)* 
#> 
#> 
#> 
#> |Sex |Treatment |  n|      Mean|       SEM|         P|Sig |
#> |:---|:---------|--:|---------:|---------:|---------:|:---|
#> |F   |AP        | 16| 0.0447956| 0.0016231|          |    |
#> |F   |Vehicle   | 16| 0.0425694| 0.0011804| 0.2761197|    |
#> |M   |AP        | 20| 0.0386190| 0.0008305|          |    |
#> |M   |Vehicle   | 16| 0.0393938| 0.0015310| 0.6605264|    |
#> 
#> 
#> ---
#> 
#> [**Tb.Sp**]{color="red"}
#> 
#> *Two-Way ANOVA* 
#> 
#> 
#> 
#> |Factor        |         P|Sig |
#> |:-------------|---------:|:---|
#> |Sex           | 0.0000000|*** |
#> |Treatment     | 0.7789508|    |
#> |Sex:Treatment | 0.8004380|    |
#> 
#> 
#> *Group Summaries (t-test comparing groups within each sex)* 
#> 
#> 
#> 
#> |Sex |Treatment |  n|      Mean|       SEM|         P|Sig |
#> |:---|:---------|--:|---------:|---------:|---------:|:---|
#> |F   |AP        | 16| 0.3847250| 0.0188278|          |    |
#> |F   |Vehicle   | 16| 0.3845125| 0.0177639| 0.9935043|    |
#> |M   |AP        | 20| 0.2945500| 0.0111613|          |    |
#> |M   |Vehicle   | 16| 0.2867875| 0.0112278| 0.6311705|    |
#> 
#> 
#> ---
#> 
#> [**Tb.N**]{color="red"}
#> 
#> *Two-Way ANOVA* 
#> 
#> 
#> 
#> |Factor        |         P|Sig |
#> |:-------------|---------:|:---|
#> |Sex           | 0.0000000|*** |
#> |Treatment     | 0.7925622|    |
#> |Sex:Treatment | 0.7155129|    |
#> 
#> 
#> *Group Summaries (t-test comparing groups within each sex)* 
#> 
#> 
#> 
#> |Sex |Treatment |  n|     Mean|       SEM|         P|Sig |
#> |:---|:---------|--:|--------:|---------:|---------:|:---|
#> |F   |AP        | 16| 2.415563| 0.1302996|          |    |
#> |F   |Vehicle   | 16| 2.402875| 0.1007043| 0.9391004|    |
#> |M   |AP        | 20| 3.056250| 0.0872782|          |    |
#> |M   |Vehicle   | 16| 3.119937| 0.0984439| 0.6310858|    |
#> 
#> 
#> ---
#> 
```

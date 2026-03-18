# Print bone microCT comparison analysis results

This function wraps and extends
[`knitr::kable()`](https://rdrr.io/pkg/knitr/man/kable.html) to format
and print the results of bone microCT comparison analyses at one site by
sex for use in an R Markdown document. A code chunk containing this
function should probably have the `results = "asis"` option to allow
pretty formatting. Any `NA` values are printed as an empty string.

## Usage

``` r
print_results(results, sig_color = "red", ...)
```

## Arguments

- results:

  A list of microCT comparison results, formatted as is the output of
  [`compare_groups()`](https://khoslalab.github.io/klct/reference/compare_groups.md).

- sig_color:

  What color to print a significant result. Defaults to `"red"`. Set to
  `NULL` to disable (and just print everything black).

- ...:

  Additional arguments passed on to
  [`knitr::kable()`](https://rdrr.io/pkg/knitr/man/kable.html).

## Value

Text output which is by default a Pandoc markdown pipe table for each
measure and each sex analyzed. If two sexes are analyzed, Pandoc fenced
div syntax is used to print the tables in two columns by sex.

## Examples

``` r
mouse_table <- read_mouse_table(klct_ex("mouse-table.csv"))
spine_trab <- read_trabecular(klct_ex("spine_trabecular_data.csv"),
                              mouse_table, site = "Spine")
spine_res <- compare_groups(spine_trab)
print_results(spine_res)
#> :::: {style="display: flex;"}
#> 
#> ::: {}
#> 
#> **Tb.BV/TV**
#> 
#> |Sex |Treatment |  n|     Mean|      SEM|         P|Sig |
#> |:---|:---------|--:|--------:|--------:|---------:|:---|
#> |F   |AP        | 16| 12.88106| 1.146596|          |    |
#> |F   |Vehicle   | 16| 12.50113| 1.297131| 0.8277794|    |
#> 
#> 
#> **Tb.Th**
#> 
#> |Sex |Treatment |  n|      Mean|       SEM|         P|Sig |
#> |:---|:---------|--:|---------:|---------:|---------:|:---|
#> |F   |AP        | 16| 0.0447956| 0.0016231|          |    |
#> |F   |Vehicle   | 16| 0.0425694| 0.0011804| 0.2761197|    |
#> 
#> 
#> **Tb.Sp**
#> 
#> |Sex |Treatment |  n|      Mean|       SEM|         P|Sig |
#> |:---|:---------|--:|---------:|---------:|---------:|:---|
#> |F   |AP        | 16| 0.3847250| 0.0188278|          |    |
#> |F   |Vehicle   | 16| 0.3845125| 0.0177639| 0.9935043|    |
#> 
#> 
#> **Tb.N**
#> 
#> |Sex |Treatment |  n|     Mean|       SEM|         P|Sig |
#> |:---|:---------|--:|--------:|---------:|---------:|:---|
#> |F   |AP        | 16| 2.415563| 0.1302996|          |    |
#> |F   |Vehicle   | 16| 2.402875| 0.1007043| 0.9391004|    |
#> 
#> 
#> :::
#> 
#> ::: {}
#> 
#> **Tb.BV/TV**
#> 
#> |Sex |Treatment |  n|     Mean|       SEM|         P|Sig |
#> |:---|:---------|--:|--------:|---------:|---------:|:---|
#> |M   |AP        | 20| 11.14910| 0.6919313|          |    |
#> |M   |Vehicle   | 16| 11.96687| 0.5408511| 0.3769105|    |
#> 
#> 
#> **Tb.Th**
#> 
#> |Sex |Treatment |  n|      Mean|       SEM|         P|Sig |
#> |:---|:---------|--:|---------:|---------:|---------:|:---|
#> |M   |AP        | 20| 0.0386190| 0.0008305|          |    |
#> |M   |Vehicle   | 16| 0.0393938| 0.0015310| 0.6605264|    |
#> 
#> 
#> **Tb.Sp**
#> 
#> |Sex |Treatment |  n|      Mean|       SEM|         P|Sig |
#> |:---|:---------|--:|---------:|---------:|---------:|:---|
#> |M   |AP        | 20| 0.2945500| 0.0111613|          |    |
#> |M   |Vehicle   | 16| 0.2867875| 0.0112278| 0.6311705|    |
#> 
#> 
#> **Tb.N**
#> 
#> |Sex |Treatment |  n|     Mean|       SEM|         P|Sig |
#> |:---|:---------|--:|--------:|---------:|---------:|:---|
#> |M   |AP        | 20| 3.056250| 0.0872782|          |    |
#> |M   |Vehicle   | 16| 3.119937| 0.0984439| 0.6310858|    |
#> 
#> 
#> :::
#> 
#> ::::
#> 
```

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
#> |Sex |Treatment |  n|     Mean|       SD|      SEM|       Diff|    CI.Low|  CI.High| Pct.Change|         P|     P.adj|Sig |
#> |:---|:---------|--:|--------:|--------:|--------:|----------:|---------:|--------:|----------:|---------:|---------:|:---|
#> |F   |AP        | 16| 12.88106| 4.586384| 1.146596|           |          |         |           |          |          |    |
#> |F   |Vehicle   | 16| 12.50113| 5.188523| 1.297131| -0.3799375| -3.917859| 3.157984|  -2.949582| 0.8278017| 0.9935045|    |
#> 
#> 
#> **Tb.Th**
#> 
#> |Sex |Treatment |  n|      Mean|        SD|       SEM|       Diff|     CI.Low|   CI.High| Pct.Change|         P|     P.adj|Sig |
#> |:---|:---------|--:|---------:|---------:|---------:|----------:|----------:|---------:|----------:|---------:|---------:|:---|
#> |F   |AP        | 16| 0.0447956| 0.0064922| 0.0016231|           |           |          |           |          |          |    |
#> |F   |Vehicle   | 16| 0.0425694| 0.0047217| 0.0011804| -0.0022262| -0.0063413| 0.0018888|  -4.969793| 0.2769481| 0.9935045|    |
#> 
#> 
#> **Tb.Sp**
#> 
#> |Sex |Treatment |  n|      Mean|        SD|       SEM|       Diff|     CI.Low|   CI.High| Pct.Change|         P|     P.adj|Sig |
#> |:---|:---------|--:|---------:|---------:|---------:|----------:|----------:|---------:|----------:|---------:|---------:|:---|
#> |F   |AP        | 16| 0.3847250| 0.0753113| 0.0188278|           |           |          |           |          |          |    |
#> |F   |Vehicle   | 16| 0.3845125| 0.0710554| 0.0177639| -0.0002125| -0.0530845| 0.0526595| -0.0552343| 0.9935045| 0.9935045|    |
#> 
#> 
#> **Tb.N**
#> 
#> |Sex |Treatment |  n|     Mean|        SD|       SEM|       Diff|     CI.Low|   CI.High| Pct.Change|         P|     P.adj|Sig |
#> |:---|:---------|--:|--------:|---------:|---------:|----------:|----------:|---------:|----------:|---------:|---------:|:---|
#> |F   |AP        | 16| 2.415563| 0.5211982| 0.1302996|           |           |          |           |          |          |    |
#> |F   |Vehicle   | 16| 2.402875| 0.4028174| 0.1007043| -0.0126875| -0.3499065| 0.3245315|   -0.52524| 0.9391328| 0.9935045|    |
#> 
#> 
#> :::
#> 
#> ::: {}
#> 
#> **Tb.BV/TV**
#> 
#> |Sex |Treatment |  n|     Mean|       SD|       SEM|     Diff|     CI.Low|  CI.High| Pct.Change|         P|     P.adj|Sig |
#> |:---|:---------|--:|--------:|--------:|---------:|--------:|----------:|--------:|----------:|---------:|---------:|:---|
#> |M   |AP        | 20| 11.14910| 3.094411| 0.6919313|         |           |         |           |          |          |    |
#> |M   |Vehicle   | 16| 11.96687| 2.163404| 0.5408511| 0.817775| -0.9680269| 2.603577|   7.334897| 0.3584361| 0.6605264|    |
#> 
#> 
#> **Tb.Th**
#> 
#> |Sex |Treatment |  n|      Mean|        SD|       SEM|      Diff|    CI.Low|   CI.High| Pct.Change|         P|     P.adj|Sig |
#> |:---|:---------|--:|---------:|---------:|---------:|---------:|---------:|---------:|----------:|---------:|---------:|:---|
#> |M   |AP        | 20| 0.0386190| 0.0037142| 0.0008305|          |          |          |           |          |          |    |
#> |M   |Vehicle   | 16| 0.0393938| 0.0061240| 0.0015310| 0.0007747| -0.002824| 0.0043735|   2.006137| 0.6605264| 0.6605264|    |
#> 
#> 
#> **Tb.Sp**
#> 
#> |Sex |Treatment |  n|      Mean|        SD|       SEM|       Diff|     CI.Low|   CI.High| Pct.Change|         P|     P.adj|Sig |
#> |:---|:---------|--:|---------:|---------:|---------:|----------:|----------:|---------:|----------:|---------:|---------:|:---|
#> |M   |AP        | 20| 0.2945500| 0.0499149| 0.0111613|           |           |          |           |          |          |    |
#> |M   |Vehicle   | 16| 0.2867875| 0.0449111| 0.0112278| -0.0077625| -0.0399544| 0.0244294|  -2.635376| 0.6271065| 0.6605264|    |
#> 
#> 
#> **Tb.N**
#> 
#> |Sex |Treatment |  n|     Mean|        SD|       SEM|      Diff|     CI.Low|   CI.High| Pct.Change|         P|     P.adj|Sig |
#> |:---|:---------|--:|--------:|---------:|---------:|---------:|----------:|---------:|----------:|---------:|---------:|:---|
#> |M   |AP        | 20| 3.056250| 0.3903198| 0.0872782|          |           |          |           |          |          |    |
#> |M   |Vehicle   | 16| 3.119937| 0.3937756| 0.0984439| 0.0636875| -0.2042438| 0.3316188|   2.083845| 0.6316053| 0.6605264|    |
#> 
#> 
#> :::
#> 
#> ::::
#> 
```

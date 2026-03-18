# Create a project skeleton to compare bone microCT data

These functions assume you are in a project root directory and create an
R Markdown file containing a pre-filled bone microCT analysis. They
create the analysis R Markdown file using the appropriate package
template.

## Usage

``` r
create_two_treatment_comparison(
  file_name = paste0(format(Sys.Date(), "%F"), "-microCT-Analysis.Rmd"),
  mayo = FALSE
)

create_two_treatment_two_sex_comparison(
  file_name = paste0(format(Sys.Date(), "%F"), "-microCT-Analysis.Rmd"),
  mayo = FALSE
)
```

## Arguments

- file_name:

  A string to name the project analysis R Markdown document. Defaults to
  a file in the style of `"YYYY-MM-DD-microCT-Analysis.Rmd"`, where
  `YYYY-MM-DD` represents today's date.

- mayo:

  Logical. If `TRUE`, create a Mayo-themed template using
  [`mayodown::mayohtml`](https://rdrr.io/pkg/mayodown/man/mayohtml.html).
  If `FALSE` (the default), use
  [`rmarkdown::html_document`](https://pkgs.rstudio.com/rmarkdown/reference/html_document.html).

## Value

Returns `TRUE` if successful.

## Details

`create_two_treatment_comparison()` creates a template for comparing two
treatment groups, analyzing each sex separately.

`create_two_treatment_two_sex_comparison()` creates a template for a
full two-way (Treatment x Sex) analysis.

Both functions accept a `mayo` argument. When `mayo = TRUE`, the
template uses
[`mayodown::mayohtml`](https://rdrr.io/pkg/mayodown/man/mayohtml.html)
for a Mayo-themed report. When `mayo = FALSE` (the default), the
template uses
[`rmarkdown::html_document`](https://pkgs.rstudio.com/rmarkdown/reference/html_document.html).

## Examples

``` r
if (FALSE) {
create_two_treatment_comparison()
create_two_treatment_comparison(mayo = TRUE)
create_two_treatment_two_sex_comparison()
create_two_treatment_two_sex_comparison(mayo = TRUE)
}
```

# Read in a mouse table

This is a wrapper around
[`readr::read_csv()`](https://readr.tidyverse.org/reference/read_delim.html)
to read in and process a mouse table CSV file that contains the lookup
table defining each sample's Animal ID, AS (key registry) number, sex,
and treatment.

## Usage

``` r
read_mouse_table(file, ...)
```

## Arguments

- file:

  The file path to the mouse table CSV file.

- ...:

  Additional arguments passed on to
  [`readr::read_csv()`](https://readr.tidyverse.org/reference/read_delim.html).

## Value

A tibble/data frame containing the mouse definitions. For example:

    | Animal ID|   AS|Sex    |Treatment |
    |:---------|----:|:------|:---------|
    | JQ10.L1  | 1579|Female |AP        |
    | JQ10.2   | 1580|Female |AP        |
    | JQ11.2   | 1581|Male   |AP        |

## Examples

``` r
mouse_table <- read_mouse_table(klct_ex("mouse-table.csv"))
```

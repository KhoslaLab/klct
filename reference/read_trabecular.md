# Read in trabecular bone data

This function reads in trabecular bone microCT data from a NeoScan CSV
file and joins it with a mouse table to add sex and treatment
information.

## Usage

``` r
read_trabecular(file, mouse_table, site, ...)
```

## Arguments

- file:

  The file path to the trabecular data CSV file. This can be either the
  spine trabecular data file or the femur metaphysis data file (which
  contains both cortical and trabecular columns).

- mouse_table:

  The mouse table object containing sample information, as created by
  the
  [`read_mouse_table()`](https://khoslalab.github.io/klct/reference/read_mouse_table.md)
  function.

- site:

  A string indicating the anatomical site. Options include `"Spine"`,
  `"Met"` (femoral metaphysis), or any custom site label. This is added
  as a `Site` column to the output.

- ...:

  Additional arguments passed on to
  [`readr::read_csv()`](https://readr.tidyverse.org/reference/read_delim.html).

## Value

A tibble/data frame containing trabecular bone data. For example:

    |   AS|Sex |Treatment |Site  | Tb.BV/TV| Tb.Th| Tb.Sp| Tb.N|
    |----:|:---|:---------|:-----|--------:|-----:|-----:|----:|
    | 1579|F   |AP        |Spine |    18.69| 0.032| 0.252| 3.52|
    | 1580|F   |AP        |Spine |    21.60| 0.045| 0.292| 2.97|

## Details

For femoral metaphysis data, the trabecular columns are extracted from
the combined cortical/trabecular file. For spine data, the file contains
only trabecular columns.

## Examples

``` r
mouse_table <- read_mouse_table(klct_ex("mouse-table.csv"))
spine_trab <- read_trabecular(klct_ex("spine_trabecular_data.csv"),
                              mouse_table,
                              site = "Spine")
```

# Read in cortical bone data

This function reads in cortical bone microCT data from a NeoScan CSV
file and joins it with a mouse table to add sex and treatment
information.

## Usage

``` r
read_cortical(file, mouse_table, site, ...)
```

## Arguments

- file:

  The file path to the cortical data CSV file. This can be the femur
  metaphysis data file or the femur diaphysis data file.

- mouse_table:

  The mouse table object containing sample information, as created by
  the
  [`read_mouse_table()`](https://khoslalab.github.io/klct/reference/read_mouse_table.md)
  function.

- site:

  A string indicating the anatomical site. Options include `"Met"`
  (femoral metaphysis) or `"Dia"` (femoral diaphysis), or any custom
  site label. This is added as a `Site` column to the output.

- ...:

  Additional arguments passed on to
  [`readr::read_csv()`](https://readr.tidyverse.org/reference/read_delim.html).

## Value

A tibble/data frame containing cortical bone data. For example:

    |   AS|Sex |Treatment |Site | Ct.vBMD| Ct.Th| Ct.Ar/Tt.Ar| Ct.Po| Ma.Ar| Ps.Pm| Es.Pm|
    |----:|:---|:---------|:----|-------:|-----:|-----------:|-----:|-----:|-----:|-----:|
    | 1579|F   |AP        |Met  |  1217.7| 0.161|       97.57|  2.43| 1.932| 6.815| 5.784|
    | 1580|F   |AP        |Met  |  1276.6| 0.180|       98.50|  1.50| 1.839| 6.732| 5.669|

## Details

For femoral metaphysis data, the cortical columns are extracted from the
combined cortical/trabecular file. For femoral diaphysis data, all
columns are cortical.

## Examples

``` r
mouse_table <- read_mouse_table(klct_ex("mouse-table.csv"))
met_cort <- read_cortical(klct_ex("femur_metaphysis_data.csv"),
                          mouse_table,
                          site = "Met")
```

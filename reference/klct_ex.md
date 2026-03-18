# Get path to klct examples

klct comes bundled with some example files in its `inst/extdata`
directory. This function makes them easy to access.

## Usage

``` r
klct_ex(path = NULL)
```

## Arguments

- path:

  Name of file. If `NULL`, the example files will be listed.

## Value

A string containing the name of the file, or a character vector
containing the names of all example files.

## Details

Adapted from `readxl::readxl_example()`.

## Examples

``` r
klct_ex()
#> [1] "femur_diaphysis_data.csv"  "femur_metaphysis_data.csv"
#> [3] "mouse-table.csv"           "spine_trabecular_data.csv"
klct_ex("mouse-table.csv")
#> [1] "/home/runner/work/_temp/Library/klct/extdata/mouse-table.csv"
```

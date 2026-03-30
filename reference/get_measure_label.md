# Get display label for a bone microCT measure

Builds a label from the measure column name and its unit string. When
`multiline = FALSE` (the default) the result is e.g. `"Ct.Th (mm)"`;
when `multiline = TRUE` the unit is placed on a second line, e.g.
`"Ct.Th\n(mm)"`, which keeps facet strips compact.

## Usage

``` r
get_measure_label(measure, multiline = FALSE)
```

## Arguments

- measure:

  A character vector of measure column names.

- multiline:

  If `TRUE`, separate the measure name and unit with a newline instead
  of a space. Useful for
  [`ggplot2::facet_wrap()`](https://ggplot2.tidyverse.org/reference/facet_wrap.html)
  strip labels where horizontal space is limited.

## Value

A character vector of display labels, the same length as `measure`.

## Details

Returns the original column name unchanged if no unit is defined.

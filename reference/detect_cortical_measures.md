# Detect cortical measure columns in a data frame

Returns all numeric column names that are not metadata and do not begin
with `"Tb."`. This captures columns prefixed with `Ct.`, `Tt.`, `Po.`,
`Ma.`, `Ps.`, `Es.`, and any other scanner-specific numeric outputs.

## Usage

``` r
detect_cortical_measures(data)
```

## Arguments

- data:

  A data frame of microCT data.

## Value

A character vector of cortical measure column names.

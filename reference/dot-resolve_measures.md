# Resolve which measures to analyze

Given the user-supplied `measures`, `type`, and the data frame, returns
the final character vector of column names to analyze.

## Usage

``` r
.resolve_measures(data, type, measures)
```

## Arguments

- data:

  A data frame of microCT data.

- type:

  `"trabecular"`, `"cortical"`, or `NULL`.

- measures:

  `NULL` (use defaults), `"all"` (use every detected column), or a
  character vector of specific column names.

## Value

A character vector of measure column names.

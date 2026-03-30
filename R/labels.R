# Measure units -------------------------------------------------------------

#' Units for bone microCT measures
#'
#' A named character vector mapping column names produced by the NeoScan
#' scanner to their unit strings (assuming mm-based output).  Used internally
#' by [get_measure_label()] to build display labels for plots.
#'
#' @keywords internal
measure_units <- c(
    # Trabecular measures
    "Tb.BV"    = "mm\u00b3",
    "Tb.TV"    = "mm\u00b3",
    "Tb.BV/TV" = "%",
    "Tb.BS"    = "mm\u00b2",
    "Tb.BS/TV" = "1/mm",
    "Tb.Th"    = "mm",
    "Tb.Sp"    = "mm",
    "Tb.N"     = "1/mm",

    # Cortical bone & envelope measures
    "Ct.BV"    = "mm\u00b3",
    "Ct.TV"    = "mm\u00b3",
    "Ct.BV/TV" = "%",
    "Ct.Ar"    = "mm\u00b2",
    "Tt.Ar"    = "mm\u00b2",
    "Ma.Ar"    = "mm\u00b2",
    "Ct.Ar/Tt.Ar" = "%",
    "Ct.BS"    = "mm\u00b2",
    "Ct.BS/TV" = "1/mm",
    "Ct.Th"    = "mm",
    "Ps.Pm"    = "mm",
    "Es.Pm"    = "mm",
    "Ct.vBMD"    = "mg HA/cm\u00b3",
    "Ct.vBMD.SD" = "mg HA/cm\u00b3",

    # Porosity measures
    "Ct.Po"          = "%",
    "Ct.Po(closed)"  = "%",
    "Ct.Po(open)"    = "%",
    "Po.V"           = "mm\u00b3",
    "Po.V(closed)"   = "mm\u00b3",
    "Po.V(open)"     = "mm\u00b3",
    "Po.Dn"          = "1/mm\u00b3",
    "Po.Dn(closed)"  = "1/mm\u00b3",
    "Po.Dn(open)"    = "1/mm\u00b3"
)


#' Get display label for a bone microCT measure
#'
#' Builds a label from the measure column name and its unit string.  When
#' `multiline = FALSE` (the default) the result is e.g. `"Ct.Th (mm)"`;
#' when `multiline = TRUE` the unit is placed on a second line, e.g.
#' `"Ct.Th\n(mm)"`, which keeps facet strips compact.
#'
#' Returns the original column name unchanged if no unit is defined.
#'
#' @param measure A character vector of measure column names.
#' @param multiline If `TRUE`, separate the measure name and unit with a
#'   newline instead of a space.  Useful for [ggplot2::facet_wrap()] strip
#'   labels where horizontal space is limited.
#' @return A character vector of display labels, the same length as `measure`.
#' @keywords internal
get_measure_label <- function(measure, multiline = FALSE) {
    unit <- measure_units[measure]
    sep <- if (multiline) "\n" else " "
    ifelse(is.na(unit), measure, paste0(measure, sep, "(", unit, ")"))
}

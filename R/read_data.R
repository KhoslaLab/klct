#' Read in a mouse table
#'
#' This is a wrapper around [readr::read_csv()] to read in and process a mouse
#' table CSV file that contains the lookup table defining each sample's Animal
#' ID, AS (key registry) number, sex, and treatment.
#'
#' @param file The file path to the mouse table CSV file.
#' @param ... Additional arguments passed on to [readr::read_csv()].
#'
#' @return A tibble/data frame containing the mouse definitions. For example:
#'   ```
#'   | Animal ID|   AS|Sex    |Treatment |
#'   |:---------|----:|:------|:---------|
#'   | JQ10.L1  | 1579|Female |AP        |
#'   | JQ10.2   | 1580|Female |AP        |
#'   | JQ11.2   | 1581|Male   |AP        |
#'   ```
#'
#' @export
#'
#' @examples
#' mouse_table <- read_mouse_table(klct_ex("mouse-table.csv"))
read_mouse_table <- function(file, ...) {
    mt <- readr::read_csv(file, show_col_types = FALSE, ...) |>
        dplyr::mutate(
            Sex = dplyr::case_when(
                Sex %in% c("Female", "female", "F") ~ "F",
                Sex %in% c("Male", "male", "M") ~ "M",
                TRUE ~ Sex
            )
        )
    mt
}

#' Read in trabecular bone data
#'
#' This function reads in trabecular bone microCT data from a NeoScan CSV file
#' and joins it with a mouse table to add sex and treatment information.
#'
#' For femoral metaphysis data, the trabecular columns are extracted from the
#' combined cortical/trabecular file. For spine data, the file contains only
#' trabecular columns.
#'
#' @param file The file path to the trabecular data CSV file. This can be either
#'   the spine trabecular data file or the femur metaphysis data file (which
#'   contains both cortical and trabecular columns).
#' @param mouse_table The mouse table object containing sample information, as
#'   created by the [read_mouse_table()] function.
#' @param site A string indicating the anatomical site. Options include
#'   `"Spine"`, `"Met"` (femoral metaphysis), or any custom site label. This is
#'   added as a `Site` column to the output.
#' @param ... Additional arguments passed on to [readr::read_csv()].
#'
#' @return A tibble/data frame containing trabecular bone data. For example:
#'   ```
#'   |   AS|Sex |Treatment |Site  | Tb.BV/TV| Tb.Th| Tb.Sp| Tb.N|
#'   |----:|:---|:---------|:-----|--------:|-----:|-----:|----:|
#'   | 1579|F   |AP        |Spine |    18.69| 0.032| 0.252| 3.52|
#'   | 1580|F   |AP        |Spine |    21.60| 0.045| 0.292| 2.97|
#'   ```
#'
#' @export
#'
#' @examples
#' mouse_table <- read_mouse_table(klct_ex("mouse-table.csv"))
#' spine_trab <- read_trabecular(klct_ex("spine_trabecular_data.csv"),
#'                               mouse_table,
#'                               site = "Spine")
read_trabecular <- function(file, mouse_table, site, ...) {
    dat <- readr::read_csv(file, show_col_types = FALSE, ...)

    tb_cols <- c("AS", "Tb.BV", "Tb.TV", "Tb.BV/TV",
                 "Tb.BS", "Tb.BS/TV", "Tb.Th", "Tb.Sp", "Tb.N")
    available <- intersect(tb_cols, names(dat))
    dat <- dat |> dplyr::select(dplyr::all_of(available))

    mt_cols <- intersect(c("AS", "Sex", "Treatment", "Genotype"), names(mouse_table))
    mt <- mouse_table |> dplyr::select(dplyr::all_of(mt_cols))

    trab <- dplyr::left_join(dat, mt, by = "AS") |>
        dplyr::mutate(Site = site) |>
        dplyr::relocate(Site, .after = dplyr::any_of(c("Treatment", "Genotype")))

    trab
}

#' Read in cortical bone data
#'
#' This function reads in cortical bone microCT data from a NeoScan CSV file
#' and joins it with a mouse table to add sex and treatment information.
#'
#' For femoral metaphysis data, the cortical columns are extracted from the
#' combined cortical/trabecular file. For femoral diaphysis data, all columns
#' are cortical.
#'
#' @param file The file path to the cortical data CSV file. This can be the
#'   femur metaphysis data file or the femur diaphysis data file.
#' @param mouse_table The mouse table object containing sample information, as
#'   created by the [read_mouse_table()] function.
#' @param site A string indicating the anatomical site. Options include
#'   `"Met"` (femoral metaphysis) or `"Dia"` (femoral diaphysis), or any custom
#'   site label. This is added as a `Site` column to the output.
#' @param ... Additional arguments passed on to [readr::read_csv()].
#'
#' @return A tibble/data frame containing cortical bone data. For example:
#'   ```
#'   |   AS|Sex |Treatment |Site | Ct.vBMD| Ct.Th| Ct.Ar/Tt.Ar| Ct.Po| Ma.Ar| Ps.Pm| Es.Pm|
#'   |----:|:---|:---------|:----|-------:|-----:|-----------:|-----:|-----:|-----:|-----:|
#'   | 1579|F   |AP        |Met  |  1217.7| 0.161|       97.57|  2.43| 1.932| 6.815| 5.784|
#'   | 1580|F   |AP        |Met  |  1276.6| 0.180|       98.50|  1.50| 1.839| 6.732| 5.669|
#'   ```
#'
#' @export
#'
#' @examples
#' mouse_table <- read_mouse_table(klct_ex("mouse-table.csv"))
#' met_cort <- read_cortical(klct_ex("femur_metaphysis_data.csv"),
#'                           mouse_table,
#'                           site = "Met")
read_cortical <- function(file, mouse_table, site, ...) {
    dat <- readr::read_csv(file, show_col_types = FALSE, ...)

    ct_cols <- c("AS", "Ct.BV", "Ct.TV", "Ct.BV/TV",
                 "Ct.Ar", "Tt.Ar", "Ct.Ar/Tt.Ar",
                 "Ct.BS", "Ct.BS/TV", "Ct.Th",
                 "Ct.Po", "Ct.Po(closed)", "Ct.Po(open)",
                 "Po.V", "Po.V(closed)", "Po.V(open)",
                 "Po.N", "Po.N(closed)", "Po.N(open)",
                 "Po.Dn", "Po.Dn(closed)", "Po.Dn(open)",
                 "Ma.Ar", "Ps.Pm", "Es.Pm",
                 "Ct.vBMD", "Ct.vBMD.SD")
    available <- intersect(ct_cols, names(dat))
    dat <- dat |> dplyr::select(dplyr::all_of(available))

    mt_cols <- intersect(c("AS", "Sex", "Treatment", "Genotype"), names(mouse_table))
    mt <- mouse_table |> dplyr::select(dplyr::all_of(mt_cols))

    cort <- dplyr::left_join(dat, mt, by = "AS") |>
        dplyr::mutate(Site = site) |>
        dplyr::relocate(Site, .after = dplyr::any_of(c("Treatment", "Genotype")))

    cort
}

# Script to load integration site data for SCID multiomics project
# 2017-08-10

library(readxl)
library(dplyr)
library(stringr)

base_fp <- "data-raw/int"

intsite_files <- Sys.glob(file.path(base_fp, "*_IntSiteData.xlsx"))

get_patient_name <- function(fp) {
  str_replace(fp, base_fp, "") %>%
    str_replace("/", "") %>%
    str_replace("_IntSiteData.xlsx", "")
}

patients <- get_patient_name(intsite_files)

intsites <- plyr::alply(intsite_files, 1, function(file) {
  patient <- get_patient_name(file)
  summary = read_excel(file, sheet="summary")
  popsize = read_excel(file, sheet="popsize")
  popsize$patient <- patient
  summary$patient <- patient
  colnames(popsize) <- make.unique(colnames(popsize))
  popsize$celltype <- str_trim(popsize$celltype)
  list(
    summary=summary,
    popsize=popsize
  )
})

names(intsites) <- patients

devtools::use_data(intsites, overwrite=TRUE)

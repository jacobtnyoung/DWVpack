# ---------------------------------- #
# Build TROUBLES FATALITIES data file


# ----
# Setup

# clear workspace
rm( list = ls() )

# load libraries needed
library( here )
source( here( "data-raw/libraries.R" ) )

# path and data
path <- here( "data-raw/data-raw-files/troubles-fatalities-raw.csv" )
dat <- read.csv( path, as.is = TRUE, header = TRUE, stringsAsFactors = FALSE )


# ----
# Cleanup

# change variable names and select what you want

dat <- dat |>
  select(
    id = Event.Number,
    lat = Latitude,
    lon = Longitude,
    age = Victim.s.Age,
    sex = Victim.s.Sex,
    affiliation = Victim.s.Sectarian.Affiliation
    )


# clean up the affiliation variable

dat <- dat |>
  mutate(
    affiliation = case_when(
      affiliation == "Christian Scientist" ~ "Other/Unknown",
      affiliation == "Hindu" ~ "Other/Unknown",
      affiliation == "Jewish" ~ "Other/Unknown",
      affiliation == "Mormon" ~ "Other/Unknown",
      affiliation == "Muslim" ~ "Other/Unknown",
      affiliation == "other" ~ "Other/Unknown",
      affiliation == "Other" ~ "Other/Unknown",
      affiliation == "Unknown" ~ "Other/Unknown",
      TRUE ~ affiliation
    )
  )


# ------------------------------ #
# ----
# Save

troubles_fatalities <- dat
use_data( troubles_fatalities, overwrite = TRUE )

# ------------------------------ #
# Build PHX CRIME data file


# ----
# Setup

rm( list = ls() )

library( dplyr )
library( usethis )
library( lubridate )
library( stringr )

url <- paste(
  "https://www.phoenixopendata.com/dataset/cc08aace-9ca9-467f-b6c1-f0879ab1a358/resource/",
  "0ce3411a-2fc6-4302-a33f-167f68608a20/download/crime-data_crime-data_crimestat.csv",
  sep = ""
)


dat <- read.csv( url, as.is = TRUE, header = TRUE )


# ----
# Cleanup

# change variable names and select what you want

dat <- dat |>
  select(
    incident_id = INC.NUMBER,
    time_date = OCCURRED.ON,
    crime_type = UCR.CRIME.CATEGORY,
    address = X100.BLOCK.ADDR,
    zipcode = ZIP,
    premise_type = PREMISE.TYPE
    )


# remove cases that have problematic date/time format
# because it makes showing the cleaning easier

dat <- dat |>
  filter(
    !is.na( time_date),
    trimws( time_date ) != "",
    !str_detect( time_date, "AM|PM" )
  )


# ------------------------------ #
# ----
# Create tidy version

# clean up the dates and times
dat_tidy <- dat |>
  mutate(
    # Parse datetime
    datetime = mdy_hm( time_date ),

    # Separate date and time
    date = as_date( datetime ),
    time = format( datetime, "%H:%M" ),

    # Create components
    year  = year( datetime ),
    month = month( datetime, label = TRUE, abbr = TRUE ),
    day   = day( datetime )
  )

# clean up the variable classifying the cases
dat_tidy <- dat_tidy |>
  mutate(
    crime_type_clean = case_when(
      crime_type == "AGGRAVATED ASSAULT" ~ "Assault",
      crime_type == "ARSON" ~ "Arson",
      crime_type == "BURGLARY" ~ "Burglary",
      crime_type == "DRUG OFFENSE" ~ "Drugs",
      crime_type == "LARCENY-THEFT" ~ "Theft",
      crime_type == "MURDER AND NON-NEGLIGENT MANSLAUGHTER" ~ "Homicide",
      crime_type == "MOTOR VEHICLE THEFT" ~ "MV Theft",
      crime_type == "RAPE" ~ "Rape",
      crime_type == "ROBBERY" ~ "Robbery" )
  )

# drop cases from 2015 (these are dropped because the 2015 cases begin in December)
dat_tidy <-
  dat_tidy %>%
  filter( year != 2015 )

# drop cases from 2025 (these are dropped because the 2025 cases end in September)
dat_tidy <-
  dat_tidy %>%
  filter( year != 2025 )


# ------------------------------ #
# ----
# Save

phx_crime <- dat
tidy_phx_crime <- dat_tidy

use_data( phx_crime, overwrite = TRUE )
use_data( tidy_phx_crime, overwrite = TRUE )


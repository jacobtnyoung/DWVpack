# --------------------------------- #
# Build TEMPE HATE crimes data file


# ----
# Setup

rm( list = ls() )

# load libraries needed
library( here )
source( here( "data-raw/libraries.R" ) )

path <- here( "data-raw/data-raw-files/tempe-hate-raw.csv" )

dat <- read.csv( path, as.is = TRUE, header = TRUE, stringsAsFactors = FALSE )


# ----
# Cleanup

# change variable names and select what you want

dat <- dat |>
  select(
    incident_id = RMS.ID,
    time_date = Date.of.Crime,
    bias_type = Type.of.Bias,
    offense_type = Type.of.Offense.Crime,
    lat = Latitude,
    lon = Longitude,
    x_cord = x,
    y_cord = y
    )


# ------------------------------ #
# ----
# Create tidy version

# clean up the dates and times
dat_tidy <- dat |>
  mutate(
    # Parse datetime
    datetime = mdy_hms( time_date ),

    # Separate date and time
    date = as_date( datetime ),
    time = format( datetime, "%H:%M" ),

    # Create components
    year  = year( datetime ),
    month = month( datetime, label = TRUE, abbr = TRUE ),
    day   = day( datetime )
  )


# clean up the offense types

# clean up the variable classifying the cases
dat_tidy <- dat_tidy |>
  mutate(
    offense_type_clean = case_when(
      offense_type == "Aggravated Assault" ~ "Assault",
      offense_type == "Aggravated Criminal Damage" ~ "Property Damage",
      offense_type == "Arson"  ~ "Property Damage",
      offense_type == "Assault"  ~ "Assault",
      offense_type == "Bomb Threat"  ~ "Assault",
      offense_type == "Burglary No Force"  ~ "Theft",
      offense_type == "Criminal Damage"  ~ "Property Damage",
      offense_type == "Criminal Damage - Vehicle"  ~ "Property Damage",
      offense_type == "Criminal Damage/Trspassing" ~ "Property Damage",
      offense_type == "Disorderly Conduct"  ~ "Harassment",
      offense_type == "Harassment"  ~ "Harassment",
      offense_type == "Harrassment"  ~ "Harassment",
      offense_type == "Intimidation"     ~ "Harassment",
      offense_type == "Non DV AGG Assault"   ~ "Assault",
      offense_type == "Non DV Assault"   ~ "Assault",
      offense_type == "Theft"      ~ "Theft",
      offense_type == "Theft Other"    ~ "Theft",
      offense_type == "Threat/Intimidate Person" ~ "Harassment"
      )
    )


# recode the values for type of bias
dat_tidy <- dat_tidy |>
  mutate(
    bias_type_clean = case_when(
      bias_type == "" ~ "Unknown",
      bias_type == "Anti-Gay (Male)" ~ "Anti-Gay" ,
      bias_type == "Anti-Lesbian (Female)"  ~ "Anti-Gay" ,
      bias_type == "Anti-Lesbian, Gay, Bisexual, or Transgender (Mixed Group)" ~ "Anti-Gay" ,
      TRUE ~ bias_type
    )
  )


# ------------------------------ #
# ----
# Save

tempe_hate <- dat
tidy_tempe_hate <- dat_tidy

use_data( tempe_hate, overwrite = TRUE )
use_data( tidy_tempe_hate, overwrite = TRUE )

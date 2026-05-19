# ------------------------------ #
# Build TUCSON BICYCLE data file


# ----
# Setup

rm( list = ls() )

library( dplyr )
library( usethis )
library( lubridate )
library( stringr )
library( here )


path <- here( "data-raw/data-raw-files/tucson-bicycle-raw.csv" )

dat <- read.csv( path, as.is = TRUE, header = TRUE, stringsAsFactors = FALSE )


# ----
# Cleanup

# change variable names and select what you want

dat <- dat |>
  select(
    accident_id = acci_id,
    time_date = AccidentDateTime,
    fatal = WasFatal,
    injury = InjuryTotal,
    x_coord = GeoX,
    y_coord = GeoY
    )


# ------------------------------ #
# ----
# Create tidy version

# clean up the dates and times
dat_tidy <- dat |>
  mutate(
    # Parse datetime
    datetime = ymd_hms( time_date ),

    # Separate date and time
    date = as_date( datetime ),
    time = format( datetime, "%H:%M" ),

    # Create components
    year  = year( datetime ),
    month = month( datetime, label = TRUE, abbr = TRUE ),
    day   = day( datetime )
  )


# ------------------------------ #
# ----
# Save

tucson_bike <- dat
tidy_tucson_bike <- dat_tidy

use_data( tucson_bike, overwrite = TRUE )
use_data( tidy_tucson_bike, overwrite = TRUE )

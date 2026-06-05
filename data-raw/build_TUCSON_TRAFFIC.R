# ------------------------------ #
# Build TUCSON TRAFFIC data file


# ----
# Setup

rm( list = ls() )

# load libraries needed
library( here )
source( here( "data-raw/libraries.R" ) )

path <- here( "data-raw/data-raw-files/tucson-traffic-raw.csv" )

dat <- read.csv( path, as.is = TRUE, header = TRUE, stringsAsFactors = FALSE )


# ----
# Cleanup

# change variable names and select what you want

dat <- dat |>
  select(
    accident_id = acci_id,
    description = offenseDesc,
    time_date = AccidentDateTime,
    fatal = WasFatal,
    injury = InjuryTotal,
    lighting = LightConditionDescription,
    weather = WeatherDescription,
    x_cord = GeoX,
    y_cord = GeoY
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

tucson_traffic <- dat
use_data( tucson_traffic, overwrite = TRUE )

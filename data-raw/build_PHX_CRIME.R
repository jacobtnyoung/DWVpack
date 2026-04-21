# ------------------------------ #
# Build PHX CRIME data file


# ----
# Setup

rm( list = ls() )

library( dplyr )
library( usethis )

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


# ----
# Save

phx_crime <- dat

use_data( phx_crime, overwrite = TRUE )

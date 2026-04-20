# ------------------------------ #
# Build PHX USE OF FORCE data file


# ----
# Setup

rm( list = ls() )

library( dplyr )
library( usethis )

url <- paste(
  "https://www.phoenixopendata.com/dataset/7df8d71f-82d5-47c3-8b08-9dfaa76c2bc0/resource/",
  "c79b2135-e936-439e-a8a3-79e61d4518d2/download/ouof_use-of-force-incident-details_detail.csv",
  sep = ""
)

dat <- read.csv(url, as.is = TRUE, header = TRUE)


# ----
# Cleanup

# take valid years
dat <- dat |>
  filter( INC_YEAR != 2025 ) |>
  filter( INC_YEAR != 2017 )

# fix the age variable

dat <- dat |>
  mutate( CIT_AGE = as.numeric( na_if( CIT_AGE, "Not Applicable" ) ) )


# ----
# Save

phx_uof_2018_2024 <- dat

usethis::use_data( phx_uof_2018_2024, overwrite = TRUE )

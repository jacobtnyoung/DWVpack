# ------------------------------ #
# Build all data files in the raw data folder


# ----
# Setup

rm( list = ls() )

library( here )

# ----
# build files to execute

source( here( "data-raw/build_PHX_CRIME.R" ) )
source( here( "data-raw/build_PHX_UOF.R" ) )
source( here( "data-raw/build_TUCSON_BICYLE.R" ) )

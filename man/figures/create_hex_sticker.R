# Code to create hex sticker for package

# Load necessary libraries
library( here )
library( hexSticker )

# Create the hex sticker
sticker(
  subplot = "man/figures/DWVpack_illustration.png",
  package = "",
  #p_size = 3.5,
  #p_y = 1.55,
  p_color = "white",
  h_fill = "white",
  h_color = "#0f2269",
  s_x = 1,
  s_y = 1.0,
  s_width = 0.8,
  filename = "man/figures/DWVpack_sticker.png"
)

library(tidyverse)

#' @import tidyverse
#' @import ggplot2
#' @import lubridate
#' @import magrittr
#' @export blue
#' @export red
#' @export color_main
#' @export color_extra
#' @export palette_light
#' @export palette_medium
#' @export palette_dark
#' @export palette_hms
#' @export palette_hms_darker



# Colors for monthly report -----------------------------------------------

blue <- "#11223a"
red <- "#ff5028"
color_main <- "#11223a"
color_extra <- "#4e5a68"


# we really need more colors. This is mixture of the new and the old palette
palette_light <- c(
  "#11223a",
  "#8cc0c6",
  "#B44C3D",
  "#E4CD63",
  "#57967C",
  "#6D7988",
  "#C3C5B5",
  "#b39271",
  "#E5B860",
  "#325C7E",
  "#B64B6A"
)

library(magrittr)
palette_medium <- palette_light %>%
  colorspace::darken()

palette_dark <- palette_light %>%
  colorspace::darken(amount = 0.2) %>%
  colorspace::desaturate(amount = 0.1)

scales::show_col(palette_light)
scales::show_col(palette_medium)
scales::show_col(palette_dark)

# Palette for the montly reports - use for areas and columns
palette_hms <- c(
  palette_light,
  palette_dark,
  palette_medium
)

# Palette for the montly reports - use for lines and dots
palette_hms_darker <- c(
  palette_dark,
  palette_medium,
  palette_light
)

colorspace::swatchplot(palette_light, palette_medium, palette_dark)

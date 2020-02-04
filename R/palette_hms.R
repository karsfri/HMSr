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
color_extra <- "#11223a"


# we really need more colors. This is mixture of the new and the old palette
palette_light <- c(
  "#11223a", # blue - main color
  "#8cc0c6", # hms2
  "#b3cfd1", # hms3
  "#b39271", # hms extra 1
  "#00aec7", # hms extra 2
  "#EC8865", # old
  "#C56BA4"  # old
)

palette_medium <- c(
  "#11223a", # blue - main color
  "#8cc0c6", # hms2
  "#b3cfd1", # hms3
  "#b39271", # hms extra 1
  "#00aec7", # hms extra 2
  "#EC8865", # old
  "#C56BA4"  # old
)

palette_dark <- c(
  "#11223a", # blue - main color
  "#8cc0c6", # hms2
  "#b3cfd1", # hms3
  "#b39271", # hms extra 1
  "#00aec7", # hms extra 2
  "#EC8865", # old
  "#C56BA4"  # old
)

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

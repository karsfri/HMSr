library(tidyverse)

#' @import tidyverse
#' @import ggplot2
#' @import lubridate
#' @import magrittr
#' @exportPattern ^[[:alpha:]]+




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


# theme for montly report -------------------------------------------------


#' theme
#'
#' @param tms
#' @import ggplot2
#'
#' @return
#' @export
#'
#' @examples
theme_hms <- function(tms = 1){

  theme_gray() +
    theme(
      text = element_text(family = "Setimo Light"),
      line = element_line(size = 0.6),
      rect = element_rect(size = 0.6),


      plot.background = element_blank(),
      panel.background = element_blank(),
      panel.grid.major.y = element_line(colour = color_extra, size = 0.04),
      panel.grid.major.x = element_blank(),

      strip.text = element_text(family = "Setimo Light", size = 7 * tms, color = "black", face = "bold"),
      strip.text.x = element_text(family = "Setimo Light", size = 7 * tms, color = "black", face = "bold"),
      strip.background = element_blank(),

      plot.title = element_text(family = "Setimo", size = 12 * tms, face = "bold", color = blue),
      plot.subtitle = element_text(family = "Setimo", size = 10 * tms, color = blue),
      plot.caption = element_text(family = "Setimo Light", size = 8 * tms, color = blue, face = "italic"),
      axis.title = element_text(size = 7 * tms),
      axis.text = element_text(colour = color_extra, size = 8 * tms),
      legend.text = element_text(colour = color_extra, size = 9 * tms),
      plot.title.position = "plot",
      # axis.text.x = element_blank(),

      axis.line = element_blank(),
      axis.ticks = element_blank(),
      legend.title = element_blank(),

      legend.position = "bottom",
      legend.key = element_rect(fill = "transparent"),
      legend.key.height = ggplot2::unit(0.4, "cm"),
      legend.key.width = ggplot2::unit(0.4, "cm")
      # aspect.ratio = 16 / 9

    )
}



# Plot helper functions ---------------------------------------------------

theme_vertical_x <- ggplot2::theme(
  axis.text.x = ggplot2::element_text(angle = 90, vjust = 0.4, hjust = 1)
)


theme_flip <- function(color = gray, ...){
  theme(
    panel.grid.major.x = element_line(color = color, ...),
    panel.grid.major.y = element_blank(),
    axis.text.x = element_text(angle = 90, vjust = 0.4, hjust = 1)
  )
}



guides_off  <- function(){
  guides(fill = FALSE, color = FALSE, alpha = FALSE)

}

flip <- function(...){
  theme_flip(...) +
    theme_vertical_x

}

geom_zero_line <- function(..., color = palette_dark[4]){
  geom_hline(yintercept = 0, color = color, ...)
}

legend_right <- theme(
  legend.position = "right",
  legend.direction = "vertical"
)

label_isk <- function(...) scales::label_dollar(prefix = "", suffix = " kr.", decimal.mark = ",", big.mark = ".", ...)
label_point <- function(...) scales::label_dollar(decimal.mark = ",", big.mark = ".", ...)
label_percent <- function(accuracy = 1, ...) scales::label_percent(accuracy = accuracy, decimal.mark = ",", big.mark = ".", ...)

label_isl <- function(accuracy = 1, scale = 1, ...){
  scales::label_comma(accuracy = accuracy, scale = scale, decimal.mark = ",", big.mark = ".", ...)
}


# Common caption names ----------------------------------------------------

cap_hms <- "Heimild: Hagdeild HMS"
cap_thjodskra <- "Heimild: Þjóðskrá Íslands"
cap_hms_thjodskra <- "Heimild: Þjóðskrá Íslands og hagdeild HMS"
cap_hagstofa <- "Heimild: Hagstofa Íslands"
cap_hms_hagstofa <- "Heimild: Hagstofa Íslands og hagdeild HMS"
cap_sedlo <- "Heimild: Seðlabanki Íslands"
cap_hms_sedlo <- "Heimild: Seðlabanki Íslands og hagdeild HMS"

# Set theme  --------------------------------------------------------------


theme_set_hms <- function(theme = theme_hms(), change_palettes = TRUE){
  # Note that this function has external effects!
  ggplot2::theme_set(theme)

  # Load fonts
  grDevices::windowsFonts(Setimo = windowsFont("Setimo"))
  grDevices::windowsFonts(`Setimo Light` = windowsFont("Setimo Light"))


  yellow <- palette_light[1]
  yellow_dark <- palette_dark[1]
  red <- palette_dark [3]


  update_geom_defaults(GeomBoxplot, list(fill = yellow))
  # update_geom_defaults(GeomBoxplot, list(outlier.color = red))
  update_geom_defaults("col", list(fill = yellow, color = NA))
  update_geom_defaults("bar", list(fill = yellow, color = NA))
  update_geom_defaults("area", list(fill = yellow, color = NA))
  update_geom_defaults("line", list(color = yellow_dark))
  update_geom_defaults("point", list(color = yellow_dark, size = 3))

  if(change_palettes){

    scale_colour_discrete <- function(...) {
      scale_colour_manual(..., values = palette_hms_darker %>% unname())
    }

    scale_fill_discrete <- function(...) {
      scale_fill_manual(..., values = palette_hms)
    }

    assign("scale_colour_discrete", scale_colour_discrete, envir = .GlobalEnv)
    assign("scale_fill_discrete", scale_fill_discrete, envir = .GlobalEnv)
  }

}











#
# test_line<- function(){
#   data("economics")
#
#   economics %>%
#     gather(var, val, -date) %>%
#     ggplot(aes(date, val, color = var)) +
#     geom_line() +
#     theme_hms() +
#     scale_color_manual(values = palette_dark)
# }
#
# test_graphs <- function(){
#   require(here)
#
#   data("economics")
#
#   economics %>%
#     gather(var, val, -date) %>%
#     ggplot(aes(date, val, color = var)) +
#     geom_line() +
#     theme_hms() +
#     scale_color_manual(values = palette_dark) +
#     scale_y_continuous(labels = label_isl()) +
#     labs(
#       title = "Lines and stuff",
#       subtitle = "With HMS colors",
#       x = NULL,
#       y = NULL,
#       caption = "Source: None of your business :P"
#     )
#
#   ggsave_both(here("test_graphs", "lines"))
#
#   economics %>%
#     filter(date == lubridate::floor_date(date, "year"), year(date) > 2000) %>%
#     gather(var, val, -date) %>%
#     ggplot(aes(date, val, color = var)) +
#     geom_col(width = 0.3) +
#     geom_point() +
#     theme_hms() +
#     scale_color_manual(values = palette_dark) +
#     scale_y_continuous(labels = label_isl()) +
#     labs(
#       title = "Lollipops and stuff",
#       subtitle = "With HMS colors",
#       x = NULL,
#       y = NULL,
#       caption = "Source: None of your business :P"
#     ) +
#     facet_wrap(~var, scales = "free_y")
#
#   ggsave_both(here("test_graphs", "lollipop"))
#
#   economics %>%
#     filter(date == floor_date(date, "year"), year(date) > 2000) %>%
#     gather(var, val, -date) %>%
#     ggplot(aes(date, val, color = var)) +
#     geom_col(width = 0.3) +
#     geom_point() +
#     theme_hms() +
#     scale_color_manual(values = palette_dark) +
#     scale_y_continuous(labels = label_isl()) +
#     labs(
#       title = "Lollipops and stuff",
#       subtitle = "With HMS colors",
#       x = NULL,
#       y = NULL,
#       caption = "Source: None of your business :P"
#     ) +
#     facet_wrap(~var, scales = "free_y", ncol = 2)
#
#   ggsave_both(here("test_graphs", "lollipop_narrow_high"), width = width_narrow, height =  height_full)
#
#   economics %>%
#     filter(date == floor_date(date, "year"), year(date) > 2000) %>%
#     gather(var, val, -date) %>%
#     ggplot(aes(date, val, fill = var)) +
#     geom_col() +
#     theme_hms() +
#     scale_color_manual(values = palette_dark) +
#     scale_y_continuous(labels = label_isl()) +
#     labs(
#       title = "Bars and stuff",
#       subtitle = "With HMS colors",
#       x = NULL,
#       y = NULL,
#       caption = "Source: None of your business :P"
#     ) +
#     facet_wrap(~var, scales = "free_y")
#
#   ggsave_both(here("test_graphs", "col"))
#
#   economics %>%
#     filter(date == floor_date(date, "year"), year(date) > 2000) %>%
#     gather(var, val, -date) %>%
#     filter(var == "pop") %>%
#     ggplot(aes(date, val)) +
#     geom_col() +
#     geom_text(aes(label = val), angle = 90, size = 3, color = "white", hjust = 1) +
#     theme_hms() +
#     scale_color_manual(values = palette_dark) +
#     scale_y_continuous(labels = label_isl()) +
#     labs(
#       title = "Bars and stuff",
#       subtitle = "With HMS colors",
#       x = NULL,
#       y = NULL,
#       caption = "Source: None of your business :P"
#     ) +
#     # facet_wrap(~var, scales = "free_y") +
#     theme(
#       panel.grid.major.y = element_blank(),
#       axis.text.y = element_blank()
#     )
#
#   ggsave_both(here("test_graphs", "col_minimal"))
#
#   economics %>%
#     filter(date == floor_date(date, "year"), year(date) > 2000) %>%
#     gather(var, val, -date) %>%
#     ggplot(aes(date, val, fill = var, color = var)) +
#     geom_area(alpha = 0.5, color = NA) +
#     geom_line() +
#     theme_hms() +
#     scale_color_manual(values = palette_dark) +
#     scale_y_continuous(labels = label_isl()) +
#     labs(
#       title = "Area and stuff",
#       subtitle = "With HMS colors",
#       x = NULL,
#       y = NULL,
#       caption = "Source: None of your business :P"
#     ) +
#     facet_wrap(~var, scales = "free_y")
#
#   ggsave_both(here("test_graphs", "area"))
#
# }

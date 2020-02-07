#' Theme for [HMS](https://www.hms.is/)
#'
#' @param fsm Font Size Multiplier
#' @import ggplot2
#'
#' @return theme
#' @export theme_hms
#'
#' @examples
#'
#'cars %>%
#'ggplot(aes(speed, dist), fill = blue) +
#'  geom_col() +
#'  labs(
#'    title = "Some title",
#'    subtitle = "Some subtitle",
#'    caption = "Some caption"
#'  ) +
#'  theme_hms()



theme_hms <- function(fsm = 1){
  grDevices::windowsFonts(Setimo = windowsFont("Setimo"))
  grDevices::windowsFonts(`Setimo Light` = windowsFont("Setimo Light"))

  theme_gray() +
    theme(
      text = element_text(family = "Setimo Light"),
      line = element_line(size = 0.6),
      rect = element_rect(size = 0.6),


      plot.background = element_blank(),
      panel.background = element_blank(),
      panel.grid.major.y = element_line(colour = color_extra, size = 0.04),
      panel.grid.major.x = element_blank(),

      strip.text = element_text(family = "Setimo Light", size = 7 * fsm, color = "black", face = "bold"),
      strip.text.x = element_text(family = "Setimo Light", size = 7 * fsm, color = "black", face = "bold"),
      strip.background = element_blank(),

      plot.title = element_text(family = "Setimo", size = 12 * fsm, face = "bold", color = blue),
      plot.subtitle = element_text(family = "Setimo", size = 10 * fsm, color = blue),
      plot.caption = element_text(family = "Setimo Light", size = 8 * fsm, color = blue, face = "italic"),
      axis.title = element_text(size = 7 * fsm),
      axis.text = element_text(colour = color_extra, size = 8 * fsm),
      legend.text = element_text(colour = color_extra, size = 7 * fsm),
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




#' Title
#'
#' @param color
#' @param ...
#'
#' @return
#' @export theme_flip
#' @export theme_vertical_x
#' @export guides_off
#' @export flip
#' @export geom_zero_line
#' @export legend_right
#'
#' @examples
theme_flip <- function(color = gray, ...){
  theme(
    panel.grid.major.x = element_line(color = color, ...),
    panel.grid.major.y = element_blank(),
    axis.text.x = element_text(angle = 90, vjust = 0.4, hjust = 1)
  )
}

theme_vertical_x <- ggplot2::theme(
  axis.text.x = ggplot2::element_text(angle = 90, vjust = 0.4, hjust = 1)
)


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




# Common caption names ----------------------------------------------------

#' @exportPattern "cap_*"
cap_hms <- "Heimild: Hagdeild HMS"
cap_thjodskra <- "Heimild: Þjóðskrá Íslands"
cap_hms_thjodskra <- "Heimild: Þjóðskrá Íslands og hagdeild HMS"
cap_hagstofa <- "Heimild: Hagstofa Íslands"
cap_hms_hagstofa <- "Heimild: Hagstofa Íslands og hagdeild HMS"
cap_sedlo <- "Heimild: Seðlabanki Íslands"
cap_hms_sedlo <- "Heimild: Seðlabanki Íslands og hagdeild HMS"

# Set theme  --------------------------------------------------------------


#' Set the HMS theme as the default theme
#'
#' @param theme
#' @param overwrite_default_palette
#'
#' @return
#' @export theme_set_hms
#'
#' @examples
theme_set_hms <- function(theme = theme_hms(), overwrite_default_palette = TRUE){
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

  if(overwrite_default_palette){

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

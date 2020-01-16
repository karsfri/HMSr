#' Title
#'
#' @param filename
#' @param plot
#' @param device
#' @param width
#' @param height
#' @param units
#' @param dpi
#' @param bg
#' @import magrittr
#' @import ggplot2
#'
#' @return
#' @exportPattern ^[[:alpha:]]+
#'
#' @examples


# common sizes of charts
width_wide_report <- (16.2 + 3)
width_narrow_report <- (8 + 3)

width_narrow <- 8.5
width_wide <- 18
height_full <- 20
height_regular <- 9
dpi_reg <- 300
dpi_high <- 700



ggsave_png <- function(filename, plot = last_plot(), device = ragg::agg_png, width = width_wide,
                       height = height_regular, units = "cm", dpi = dpi_reg, bg = "white", ...){
  ggsave(filename = filename, plot = plot, device = device, width = width, height = height, units = units,
         res = dpi, background = bg, ...)
}

ggsave_svg <- function(filename, plot = last_plot(), device = "svg", width = width_wide,
                       height = height_regular, units = "cm", dpi = dpi_reg, ...){
  ggsave(filename = filename, plot = plot, device = device, width = width, height = height, units = units,
         dpi = dpi, ...)
}

ggsave_both <- function(filename, plot = last_plot(), width = width_wide,
                        height = height_regular, units = "cm", dpi = dpi_reg, bg = "white", ...){

  # save as png
  ggsave(filename = paste0(filename, ".png"), plot = plot, device = "png", width = width, height = height, units = units,
         dpi = dpi, ...)

  # save as svg
  ggsave(filename = paste0(filename, ".svg"), plot = plot, device = "svg", width = width, height = height, units = units,
         dpi = dpi, bg = bg, ...)
}


#' Label functions
#'
#' @import ggplot2
#' @export label_isl
#' @export label_isk
#' @export label_point
#' @export label_percent_isl
#' @export label_yy
#'
label_isk <- function(...) scales::label_dollar(prefix = "", suffix = " kr.", decimal.mark = ",", big.mark = ".", ...)
label_point <- function(...) scales::label_dollar(decimal.mark = ",", big.mark = ".", ...)
label_percent_isl <- function(accuracy = 1, ...) scales::label_percent(accuracy = accuracy, decimal.mark = ",", big.mark = ".", ...)

label_isl <- function(accuracy = 1, scale = 1, ...){
  scales::label_comma(accuracy = accuracy, scale = scale, decimal.mark = ",", big.mark = ".", ...)
}

label_yy <- function(...) scales::label_date("'%y", ...)

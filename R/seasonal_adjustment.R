

#' Seasonal Adjustment
#'
#' @param x
#' @param date
#' @param frequency
#' @param ...
#'
#' @return
#' @import broom
#' @import tidyverse
#' @import lubridate
#' @import seasonal
#' @exportPattern ^[[:alpha:]]
#'
#' @examples
#'
#'
tidy_seas <- function(x, date, frequency = 12, return = "final", ...){
  # return = c("final", "seasonal", "seasonaladj", "trend", "irregular", "adjustfac")

  start <- min(date)
  start <- year(start) + month(start) / 12
  ts_data <- ts(x, start = start, frequency = frequency)

  adjusted <- adjust(ts_data)

  adjusted %>%
    pluck(return)

}

#'
#' @return
#' @import broom
#' @import tidyverse
#' @import lubridate
#' @import seasonal
#' @exportPattern ^[[:alpha:]]
#'
#' @examples
#'
#'
adjust <- function(ts_data, ...){
  ts_data %>%
    seas(...) %>%
    pluck("data") %>%
    as_tibble()
}
#
# map_seas <- function(data, var, date){
#   var <- enquo(var)
#   date <- enquo(date)
#   data %>%
#     nest() %>%
#     mutate(seas = map(data, ~nested_seas(., !!var, !!date))) %>%
#     select(-data) %>%
#     unnest(c(seas))
# }

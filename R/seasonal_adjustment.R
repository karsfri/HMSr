

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

  stopifnot(length(date) == length(unique(date)))

  ts_data <- col_to_ts(x, start = min(date), frequency = frequency)
  adjusted <- adjust(ts_data)
  adjusted %>%
    pluck(return)
}


seas_seasonally_adjusted <- function(x, date, frequency = 12, ...){
  tidy_seas(x = x, date = date, frequency = frequency, return = "final", ...)
}

seas_seasonal_components <- function(x, date, frequency = 12, ...){
  tidy_seas(x = x, date = date, frequency = frequency, return = "seasonal", ...)
}

seas_trend <- function(x, date, frequency = 12, ...){
  tidy_seas(x = x, date = date, frequency = frequency, return = "trend", ...)
}

seas_irregular <- function(x, date, frequency = 12, ...){
  tidy_seas(x = x, date = date, frequency = frequency, return = "irregular", ...)
}

seas_adjustfac <- function(x, date, frequency = 12, ...){
  tidy_seas(x = x, date = date, frequency = frequency, return = "adjustfac", ...)
}


col_to_ts <- function(x, start, frequency){
  start <- year(start) + month(start) / 12
  ts_data <- ts(x, start = start, frequency = frequency)
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

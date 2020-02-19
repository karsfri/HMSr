

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
#' @export tidy_seas
#' @export nested_seas
#' @exportPattern "seas_"
#'
#' @examples
#'
#'
tidy_seas <- function(x, date, frequency = 12, ...){

  stopifnot(length(date) == length(unique(date)))

  ts_data <- col_to_ts(x, start = min(date), frequency = frequency)
  adjusted <- adjust(ts_data, ...)
  adjusted
}


col_to_ts <- function(x, start, frequency){
  start <- year(start) + month(start) / 12
  ts_data <- ts(x, start = start, frequency = frequency)
}

#' Adjust
#' @return
#' @import tidyverse
#' @import seasonal
#' @export adjust
#' @exportPattern "seas_"
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

seas_seasonally_adjusted <- function(x, date, frequency = 12, ...){
  tidy_seas(x = x, date = date, frequency = frequency, ... ) %>%
    pluck("final")
}

seas_seasonal_components <- function(x, date, frequency = 12, ...){
  tidy_seas(x = x, date = date, frequency = frequency, ...) %>%
    pluck("final")
}

seas_trend <- function(x, date, frequency = 12, ...){
  tidy_seas(x = x, date = date, frequency = frequency, ...) %>%
    pluck("trend")
}

seas_irregular <- function(x, date, frequency = 12, ...){
  tidy_seas(x = x, date = date, frequency = frequency, ...) %>%
    pluck("irregular")
}

seas_adjustfac <- function(x, date, frequency = 12, ...){
  tidy_seas(x = x, date = date, frequency = frequency, ...) %>%
    pluck("adjustfac")
}

#' Seasonal Adjustment (map)
#'
#' @param x
#' @param date
#' @param frequency
#' @param ...
#'
#' @return
#' @import tidyverse
#' @import lubridate
#' @import seasonal
#'
#'
nested_seas <- function(data, var, date, frequency = 12, ...){

  var <- enquo(var)
  date <- enquo(date)

  tx <- data %>% select(!!var) %>%  pull(1)
  date_series <- data %>% select(!!date) %>% pull(1)

  tidy_seas(tx, date_series, frequency = frequency, ...)

}

#' Seasonal Adjustment (map)
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
#' @export map_seas
#'
#' @examples
#'
#'
map_seas <- function(data, var, date){


  var <- enquo(var)
  date <- enquo(date)

  stopifnot(NROW(data %>% count(!!date)) == NROW(data))

  df_nested <- data %>%
    nest(data = c(!!var,!!date)) %>%
    mutate(seas = map(data, ~nested_seas(., !!var, !!date))) %>%
    unnest(cols = c(data, seas)) %>%
    gather(seasonal_component, seasonal_value, -!!date, -(!!!groups(data)))
}



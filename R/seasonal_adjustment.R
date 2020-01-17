

#' Title
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
#' @export
#'
#' @examples
#'
#'
tidy_seas <- function(x, date, frequency = 12, ...){

  start <- min(date)
  start <- year(start) + month(start) / 12
  x <- ts(x, start = start, frequency = frequency)

  x %>%
    seas(...) %>%
    pluck("data") %>%
    as_tibble()

}
#
# nested_seas <- function(data, x, date, frequency = 12, ...){
#   x <- enquo(x)
#   date <- enquo(date)
#
#   tx <- data %>% select(!!x) %>%  pull(1)
#   date_series <- data %>% select(!!date) %>% pull(1)
#
#   tidy_seas(tx, date_series, frequency = frequency, ...) %>%
#     bind_cols(data %>% select(-!!date))
#
# }
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

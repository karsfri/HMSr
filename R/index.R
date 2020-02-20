

#' Indexing a time series
#'
#' Scales a time series in such a way that it gets the value 100 at a given point in time
#'
#' @param val a numeric variable to scale
#' @param time_var time variable or other indexing variable
#' @param at_time the time or index value at the base year
#'
#' @return A scaled series.
#' @export index
#'
#' @examples
#' economics_long %>%
#'  group_by(variable) %>%
#'  mutate(val = index(value, date))
#'
#'
index <- function(val, time_var, at_time = min(time_var[!is.na(val)], na.rm = TRUE)){
  stopifnot( class(time_var) == class(at_time) )
  stopifnot(at_time %in% time_var)
  if(length(time_var) != length(unique(time_var))) stop("Non unique time variable\nDid you forget to use grooping variable?")

  val / val[time_var == at_time] * 100
}



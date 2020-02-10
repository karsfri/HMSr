#' Adjust by cpi, i.e. set to current prices
#'
#' @param df
#' @param vars Variables to adjust
#' @param timevar Date variable
#' @param at_date Date to adjust to
#'
#' @return df with adjusted series
#' @import tidyverse
#' @import glue
#' @import lubridate
#' @export cpi_adjust
#'
#' @examples yfirverd <- yfirverd_get_data()
#'
#'yfirverd %>%
#'   sql_clean() %>%
#'   cpi_adjust(
#'   vars = vars(Kaupverd, AuglystSoluverd),
#'   timevar = Dim_Timi_Utgefid
#'   )
#'
cpi_adjust <- function(df, vars, timevar, at_date = NULL){

  timevar2 <- enquo(timevar)

  # find the maximum date for which all variables are selected
  vnv <- get_vnv()

  vnv_date <- max(vnv$timi)
  df_date <- df %>%
    drop_na(!!!vars) %>%
    summarise(
      max_time = max(!!timevar2)
    ) %>%
    .$max_time

  date_used <- max(vnv_date, df_date)

  if(!is.null(at_date)) date_used <- at_date

  message(glue::glue("Selected columns set at {date_used} price levels"))

  # price level at date
  stopifnot(date_used %in% vnv$timi)

  price_level <- vnv %>%
    filter(timi == date_used) %>%
    .$vnv

  stopifnot(length(price_level) == 1)


  df %>%
    mutate(
      floored_date = floor_date(!!timevar2, "month")
    ) %>%
    left_join(vnv, by = c("floored_date" = "timi")) %>%
    mutate_at(vars, ~ . / vnv * price_level) %>%
    select(-floored_date)

}



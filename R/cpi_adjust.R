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

  vnv <- get_vnv()

  # price level at date
  if(!is.null(at_date)){
    stopifnot(at_date %in% vnv$timi)
  } else {
    at_date <- max(vnv$timi)
  }

  message(glue::glue("Selected columns set at {date_used} price levels"))

  # price level at given time
  price_level <- vnv %>%
    filter(timi == at_date) %>%
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



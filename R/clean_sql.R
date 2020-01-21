# clean_sql_data ----------------------------------------------------------

#' Title
#'
#' @param df
#' @import magrittr
#' @import dplyr
#' @import lubridate
#'
#' @return
#' @export string_to_date
#' @export int_to_double
#' @export sql_clean
#'
#' @examples
#'
#'

string_to_date <- function(df){
  # require(dplyr)
  df %>%
    collect() %>%
    mutate_at(
      vars(contains("timi"), contains("DATE")),
      ~ ymd(.)
    )
}

int_to_double <- function(df){
  df %>%
    collect() %>%
    mutate_if(is.integer, "as.double")
}

sql_clean <- function(df){

  df %>%
    string_to_date %>%
    int_to_double
}

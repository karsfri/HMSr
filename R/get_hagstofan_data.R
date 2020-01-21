#' Title
#'
#' @return
#' @import lubridate
#' @import tidyverse
#' @export get_visitala_launa
#'
#' @examplse
get_visitala_launa <- function(){
  read_hagstofan(
    "https://px.hagstofa.is:443/pxis/sq/ca030daf-96e0-4e07-bbab-586a9beb0d0e",
    decimal_mark = ".",
    grouping_mark = ","
  ) %>%
    rename(Gildi = 4) %>%
    mutate(
      timi = ymd(paste(Ár, Mánuður, "01")),
      Vísitala = "Launavísitala"
    ) %>%
    select(Gildi, timi, Vísitala)
}


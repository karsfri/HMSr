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

#' @export get_vnv
get_vnv <- function(link = "https://px.hagstofa.is:443/pxis/sq/8a441d5e-3081-4f41-90df-f6963f47c5a4"){
  vnv <- read_hagstofan_alt(link) %>%
    rename(vnv = 3) %>%
    mutate(
      timi = lubriyear(Ár, Mánuður),
      vnv = as.double(vnv)
    ) %>%
    select(timi, vnv) %>%
    drop_na()

  return(vnv)
}

#' @export get_vnv_annual
get_vnv_annual <- function(link = "https://px.hagstofa.is:443/pxis/sq/db2e94a5-e256-4990-be48-9793824a7cd4"){
  read_hagstofan_alt(link) %>%
    rename(vnv = 5) %>%
    mutate(
      timi = lubriyear(Ár),
      vnv = as.double(vnv)
    ) %>%
    select(timi, vnv) %>%
    drop_na()
}

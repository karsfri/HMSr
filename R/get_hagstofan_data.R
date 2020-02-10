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

#' @import pxweb
#' @export get_vnv
get_vnv <- function(){

  vnv_query <- '
    {
      "query": [
        {
          "code": "Ár",
          "selection": {
            "filter": "all",
            "values": ["*"]
          }
        },
        {
          "code": "Mánuður",
          "selection": {
            "filter": "item",
            "values": ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"]
          }
        },
        {
          "code": "Vísitala",
          "selection": {
            "filter": "item",
            "values": ["0"]
          }
        },
        {
          "code": "Breytingar",
          "selection": {
            "filter": "item",
            "values": ["0"]
          }
        }
      ],
      "response": {
        "format": "json"
      }
    } '

  px_data <-
    pxweb::pxweb_get(url = "http://px.hagstofa.is//pxis/api/v1/is/Efnahagur/visitolur/1_visitalaneysluverds/1_neysluverd/VIS01000.px",
              query = vnv_query,
              verbose = FALSE
              )

  vnv <-
    suppressWarnings(
      as.data.frame(px_data, stringsAsFactors = FALSE)
    ) %>%
    as_tibble() %>%
    rename(vnv = 5) %>%
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





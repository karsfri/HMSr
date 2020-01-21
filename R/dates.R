
#' Wrapper for for lubridate
#'
#' @param year
#' @param month
#' @import lubridate
#' @import magrittr
#' @return
#' @export lubriyear
#'
#' @examples
lubriyear <- function(year, month = "01"){
  ymd(paste(year, month, "01", sep = "-"))
}

#' Wrapper for for lubridate
#'
#' @param YYYYMM
#' @import lubridate
#' @import magrittr
#' @return
#' @export lubriYYYYMM
#'
#' @examples
lubriYYYYMM <- function(YYYYMM){
  require(lubridate)
  require(tidyverse)
  lubriyear(str_sub(YYYYMM, 1,4), str_sub(YYYYMM, 6,7))
}

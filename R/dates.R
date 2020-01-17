
#' wrappers for for lubridate
#'
#' @param year
#' @param month
#' @import lubridate
#' @import magrittr
#' @return
#' @exportPattern ^[[:alpha:]]
#'
#' @examples
lubriyear <- function(year, month = "01"){
  ymd(paste(year, month, "01", sep = "-"))
}

lubriYYYYMM <- function(YYYYMM){
  require(lubridate)
  require(tidyverse)
  lubriyear(str_sub(YYYYMM, 1,4), str_sub(YYYYMM, 6,7))
}

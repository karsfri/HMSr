#' get_connection_windows
#'
#' @return
#' @import odbc
#' @import DBI
#' @export
#'
#' @examples
get_connection_windows <- function(db = c("HgrDwh_Prod", "HgrDev")){
  dbConnect(odbc(), db, timeout = 10, encoding = "WINDOWS-1252")
}

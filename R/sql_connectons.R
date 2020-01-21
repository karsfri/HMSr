#' get_connection_windows
#'
#' @return a connection to the HMS database
#' @param db Name of the dsn, either "HgrDwh_Prod" or "HgrDev"
#' @import odbc
#' @import DBI
#' @export get_connection_windows
#' @examples
get_connection_windows <- function(db = "HgrDwh_Prod"){
  dbConnect(odbc(), db, timeout = 10, encoding = "WINDOWS-1252")
}

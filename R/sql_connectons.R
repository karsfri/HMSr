#' get_connection_windows
#'
#' @return a connection to the HMS database
#' @param db Name of the dsn, either "HgrDwh_Prod" or "HgrDev"
#' @import odbc
#' @import DBI
#' @import RJDBC
#' @export get_connection_windows
#' @export get_connection_HMS
#' @export get_connection_JDBC
#' @examples
get_connection_windows <- function(db = "HgrDwh_Prod"){
  dbConnect(odbc(), db, timeout = 10, encoding = "WINDOWS-1252")
}

get_connection_HMS <- function(dbhost = "sql02", dname="HgrDwh"){
  return (  dbConnect(odbc::odbc(),
                      .connection_string = sprintf('driver={SQL Server};server=%s;database=%s;trusted_connection=true',dbhost,dbname),
                      timeout = 10, encoding = "WINDOWS-1252"
                      )
  )
}

get_connection_JDBC <- function(dbhost = "sql02", dbname="HgrDwh",dbcp="D:/R/Drivers/mssql-jdbc-7.2.1.jre8.jar",user,password){
  drv <- JDBC(driverClass="com.microsoft.sqlserver.jdbc.SQLServerDriver", classPath=dbcp)
  conn <- dbConnect(drv, url=sprintf("jdbc:sqlserver://%s;DatabaseName=%s",dbhost,dbname), user=user, password=password)
  return (conn)
}

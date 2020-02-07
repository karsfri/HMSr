#' get_connection_windows
#'
#' @return a connection to the HMS database
#' @param db Name of the dsn, either "HgrDwh_Prod" or "HgrDev"
#' @import odbc
#' @import DBI
#' @export get_connection_windows
#' @export
#' @export
#' @examples get_connection_windows()
get_connection_windows <- function(db = "HgrDwh_Prod"){
  dbConnect(odbc(), db, timeout = 10, encoding = "WINDOWS-1252")
}

#' get_connection_HMS Uses ODBC to connect directly to a named server. Uses Windows Authenication.
#'
#' @param dbhost SQL Server hostname
#' @param dname  SQL Databse name
#'
#' @return DBI conection object
#' @export get_connection_HMS
#'
#' @examples HMSr::get_connection_HMS('sql02','HgrDwh')
#'
get_connection_HMS <- function(dbhost = "sql02", dname="HgrDwh"){
  return (  dbConnect(odbc::odbc(),
            .connection_string = sprintf('driver={SQL Server};server=%s;database=%s;trusted_connection=true',dbhost,dbname),
            timeout = 10, encoding = "WINDOWS-1252"
          )
  )
}

#' get_connection_JDBC Connects to a database server using JDBC
#'
#' @param dbhost Hostname name to connect to
#' @param dbname Databse name to connect to
#' @param dbcp Class path for driver
#' @param user Username
#' @param password Password
#'
#' @return DBI conection object
#' @export get_connection_JDBC
#'
#' @examples conn <- HMSr::get_connection_JDBC(dbcp="D:/R/Drivers/mssql-jdbc-7.2.1.jre8.jar',user="Bob",password ="Password01")
#
get_connection_JDBC <- function(dbhost = "sql02", dbname="HgrDwh",dbcp="D:/R/Drivers/mssql-jdbc-7.2.1.jre8.jar",user,password){
  drv <- JDBC(driverClass="com.microsoft.sqlserver.jdbc.SQLServerDriver", classPath=dbcp)
  conn <- dbConnect(drv, url=sprintf("jdbc:sqlserver://%s;DatabaseName=%s",dbhost,dbname), user=user, password=password)
  return (conn)
}


#' Access specific table from the datawarehouse.
#'
#' Thin wrapper around tbl from dbplyr. Allows the user to use some of the common
#' dplyr function on an object without importing it to R.
#'
#' @param tbl Name of the table in the datawarehouse
#' @param con Connection to the datawarehouse
#' @param schema
#'
#' @return tbl object to use with warehouse. See https://dbplyr.tidyverse.org/
#' @importFrom dplyr tbl
#' @export get_tbl
#'
#' @examples visitolur <- get_tbl(Fact_Visitolur)
#'
#' visitolur %>%
#'   filter(dim_visitolur == 3) %>%
#'   collect()
get_tbl <- function(tbl, con = get_connection_windows(), schema = "dwh"){
  tbl(con, dbplyr::in_schema("dwh", tbl))
}

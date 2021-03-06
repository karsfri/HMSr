% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sql_connectons.R
\name{get_connection_HMS}
\alias{get_connection_HMS}
\title{get_connection_HMS Uses ODBC to connect directly to a named server. Uses Windows Authenication.}
\usage{
get_connection_HMS(dbhost = "sql02", dname = "HgrDwh")
}
\arguments{
\item{dbhost}{SQL Server hostname}

\item{dname}{SQL Databse name}
}
\value{
DBI conection object
}
\description{
get_connection_HMS Uses ODBC to connect directly to a named server. Uses Windows Authenication.
}
\examples{
HMSr::get_connection_HMS('sql02','HgrDwh')

}

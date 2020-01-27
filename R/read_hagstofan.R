
# read functions ----------------------------------------------------------

#' Read data from Hagstofa Íslands (Statistics Iceland)
#'
#' @param file
#' @param na
#' @param encoding
#' @param decimal_mark
#' @param grouping_mark
#' @param delim
#' @param ...
#'
#' @return
#' @import tidyverse
#' @export read_hagstofan
#' @export read_hagstofan_alt
#' @examples
#'
read_hagstofan <- function(
  file,
  na = "..",
  encoding = "WINDOWS-1252",
  decimal_mark = ",",
  grouping_mark = ".",
  delim = ";",
  ...
){
  readr::read_delim(
    file = file,
    delim = delim,
    na = na,
    locale = readr::locale(
      encoding = encoding,
      decimal_mark = decimal_mark,
      grouping_mark = grouping_mark
    ),
    ...
  )
}

#' Read data from Hagstofa Íslands (Statistics Iceland)
#' @description
#' The same as read_hagstofan, but with dots as decimal marks.
#' @param file
#' @param na
#' @param encoding
#' @param decimal_mark
#' @param grouping_mark
#' @param delim
#' @param ...
#'
#' @return
#' @import tidyverse
#' @export read_hagstofan
#' @export read_hagstofan_alt
#' @examples
read_hagstofan_alt <- function(
  file,
  na = "..",
  encoding = "WINDOWS-1252",
  decimal_mark = ".",
  grouping_mark = ",",
  delim = ";",
  ...
){
  readr::read_delim(
    file = file,
    delim = delim,
    na = na,
    locale = readr::locale(
      encoding = encoding,
      decimal_mark = decimal_mark,
      grouping_mark = grouping_mark
    ),
    ...
  )
}

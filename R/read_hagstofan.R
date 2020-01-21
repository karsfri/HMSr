
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
  read_delim(
    file = file,
    delim = delim,
    na = na,
    locale = locale(
      encoding = encoding,
      decimal_mark = decimal_mark,
      grouping_mark = grouping_mark
    ),
    ...
  )
}


read_hagstofan_alt <- function(
  file,
  na = "..",
  encoding = "WINDOWS-1252",
  decimal_mark = ".",
  grouping_mark = ",",
  delim = ";",
  ...
){
  read_delim(
    file = file,
    delim = delim,
    na = na,
    locale = locale(
      encoding = encoding,
      decimal_mark = decimal_mark,
      grouping_mark = grouping_mark
    ),
    ...
  )
}

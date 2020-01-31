#' ColourText
#'
#' @param x Text to be coloured in either HTML or LaTeX
#' @param color Colour to be used
#'
#' @return Returns the coloured text to be used in-line in RMD documents
#' @export ColourText
#'
#' @examples
#' To be used in-line in Rmd Documents
#' # `r ColourText("MY RED TITLE",'red')`
#' `r ColourText("MY RED TEXT",'red')`
#'
#'
ColourText = function(x,color){
  outputFormat = knitr::opts_knit$get("rmarkdown.pandoc.to")
  if(outputFormat == 'latex')
    paste("\\textcolor{",color,"}{",x,"}",sep="")
  else if(outputFormat == 'html')
    paste("<font color='",color,"'>",x,"</font>",sep="")
  else
    x
}


#' GenerateDocumentation
#'
#' @description This function with auto generate pdf documentaion. It requires Roxygen comments to be **inside** the function to be documented
#' It also requires Miktex to be installed correctly.
#' It will also allow documented functions to appear in R help using help(function_name) or ?function_name
#' It currently writes the Documentation to the HMS_DS directory structure in HMS_DS/HMS_Economics/Reference/AnalysisDocumentation/
#' However it will take an argument DocDir to alter this.
#' Code has been stolen and edited from the docsting package.
#' @note It will currently understand the following tags:
#' @note return description to describe the output that a function creates.
#' @note title, description, details are available if you want to be more explicit in the sections. This also allows you to have a description section longer than one paragraph if you explicitly use the description keyword.
#' @note param list the parameters used in the function
#' @note note Creates a note section
#' @note section SectionTitle: You can create your own sections using the section keyword. Following section must be the section title in sentence case and must be finished with a colon. Subsections do not have their own keyword but can be added using the Rd backslash subsection{} command.
#' @note usage If you want to have more control over the usage section you can either overwrite the generated usage or add to it by using this keyword
#' @note references If you want to add references to your documentation. This is important (and appreciated) especially when you are writing a function that implements an algorithm in a journal article. Having a reference to the source is vital in those situations.
#' @note examples which will create an examples section in the documentation. Using docstring there isn't a nice way to run the examples like you can using the example() function but they will still show up in the documentation which is sometimes the most important part. Users can still copy/paste if they desire.
#' @note Comments do not need to be consecutive they could be throughout the function.
#'
#'
#' @param fun a function to document ( will error if no r oxygen comments in it)
#' @param fun_name defaults to a string of the function name, otherwise defines the name the documentaion file will be named
#' @param rstudio_pane to write the help to rstudio
#' @param default_title If you want to change the title text (untested)
#' @param DocDir a directory for the documentaion to reside in (defaults to the documentation dir within the HMS_DS Git repo, otherwise this will need to be set for this to work)
#' @import roxygen2
#' @import cgwtools
#' @return The function returns nothing but should write pdf documentation to the directory specified
#' @export GenerateDocumentation
#'
#' @examples # define a function with R oxygen comments
#' #' square <- function(x){
#' #' Square a number
#'
#' #' Calculates the square of the input
#'
#' #' param x the input to be squared
#'  return(x^2)
#' }
#'
#' Call the GenerateDocumentation function
#' GenerateDocumentation(square)
#'
GenerateDocumentation <- function(fun, fun_name = as.character(substitute(fun)),
                                  rstudio_pane = getOption("docstring_rstudio_help_pane"),
                                  default_title = "Title not detected",
                                  DocDir=paste0(here::here(),'/HMS_Economics/Reference/AnalysisDocumentation/') ) {


  roxy_text <- docstring_to_roxygen(fun, fun_name = fun_name,
                                    default_title = default_title)
  temp_dir <- tempdir()


  package_name <- "TempPackage"
  package_dir <- file.path(temp_dir, package_name)
  if (file.exists(package_dir)) {
    unlink(package_dir, recursive = TRUE)
  }
  j <- new.env(parent = emptyenv())
  j$a <- 0
  suppressMessages(package.skeleton(name = package_name, path = temp_dir,
                                    environment = j))
  if (!file.exists(file.path(package_dir, "R"))) {
    dir.create(file.path(package_dir, "R"))
  }
  temp_file <- file.path(package_dir, "R", paste0(fun_name,
                                                  ".R"))
  cat(roxy_text, file = temp_file)
  output <- capture.output(suppressWarnings(suppressMessages(roxygenize(package_dir,
                                                                        "rd"))))

  # Created Rd file                                                                                                                                           "rd"))))
  generated_Rd_file <- file.path(package_dir, "man",
                                 paste0(fun_name, ".Rd"))

  texdirpath <- paste0(DocDir, "texfiles/")
  texpath <- paste0(DocDir, "texfiles/", fun_name, ".tex")
  pdfpath <- paste0(DocDir, fun_name, ".pdf")
  logofile <- paste0(DocDir, "texfiles/HMS_Blue_Crop.png")

  # Create dir for the tex files if it does not exist
  ifelse(!dir.exists(file.path(texdirpath)), dir.create(file.path(texdirpath)), FALSE)

  # Create latex file from Rd file
  tools::Rd2latex(generated_Rd_file, out = texpath, stages = "render", writeEncoding =FALSE)

  # Add in required extra Latex

  subtitle <- paste0("\\author{ Function: ", gsub("_", " ", fun_name), "}")

  # If HMS logo add in title (Cant add to header or top of doc because of formatting in RD package)
  if(file.exists(logofile)){
    LatexTitle <- paste0("\\title{\\includegraphics[width=3cm]{",logofile,"} \\\\ R Documetation}")
  }else{
    LatexTitle <- "\\title{HMS: R Documetation}"
  }


  fConn <- file(texpath, 'r+')
  Lines <- readLines(fConn)
  Lines <- paste(Lines, collapse='\n')

  writeLines(paste("\\documentclass{article}",
                   "\\usepackage[utf8]{inputenc}",
                   "\\usepackage{Rd}",
                   "\\usepackage{graphicx}",
                   "\\begin{document}",
                   LatexTitle,
                   subtitle,
                   "\\date{Document Updated: \\today}",
                   "\\maketitle",
                   Lines,
                   "\\end{document}\n",
                   sep = "\n"),
             con = fConn)

  close(fConn)


  #latexpdf::tex2pdf(outputdir, dir = 'D:/Code/HMS_DS/HMS_Economics/Code/Analyses/Finalised')

  # Write to the documentation dir using texi2pdf
  # (unfortunatly cannot set output dir so currently using pushd and popd )

  cgwtools::pushd(DocDir)
  try(tools::texi2pdf(texpath, clean = TRUE),
      stop(error="PDF file cannot be overwritten since it is currently open. Please close the file and try again.",
           warning=""))

  cgwtools::popd()
  print(paste0("Documentation written to ", DocDir, " in file ", fun_name, ".pdf"))
}




#' docstring_to_roxygen
#'
#' @description This function has been stolen from the docsting package.
#' It takes a function and returns the text of the ROxygen comments erros if there are none.
#'
#'
#' @param fun a function to document ( will error if no r oxygen comments in it)
#' @param fun_name defaults to a string of the function name, otherwise defines the name the documentaion file will be named
#' @param default_title If you want to change the title text (untested)
#' @import roxygen2

#' @return The function returns the text from r oxygen comments
#' @export docstring_to_roxygen

docstring_to_roxygen <- function(fun, fun_name = as.character(substitute(fun)),
                                 default_title = "Title not detected", error = TRUE){

  # Right now this extracts any roxygen style comments
  # and they don't need to be consecutive.
  # The code then removes the leading spaces because our intent is
  # to put this above a generated function to be valid roxygen
  # style comments
  values <- capture.output(print(fun))
  roxy_ids <- grepl("^[[:space:]]*#\'", values)

  if(!any(roxy_ids)){
    if(error){
      stop("This function doesn't have any detectable docstring")
    }else{
      return(NA)
    }

  }

  roxy_strings <- values[roxy_ids]
  roxy_strings <- gsub("^[[:space:]]*", "", roxy_strings)

  blanks <- grepl("^[[:space:]]*#\'[[:space:]]*$", values)
  keywords <- grepl("^[[:space:]]*#\'[[:space:]]*@", values)

  # If there are any blanks or keywords then leave it be.
  # otherwise stick the default title at the beginning
  if(!any(blanks) & !any(keywords)){
    roxy_strings <- c(paste("#'", default_title), "#' ", roxy_strings)
  }


  roxy <- paste0(roxy_strings, collapse = "\n")


  funargs <- capture.output(args(fun))

  # capture.output(args(fun)) doesn't show the function definition
  # instead just giving something of the form:
  #
  # function(x, y, ...)
  # NULL
  #
  # but what we want in our file is something that looks like:
  #
  # fun_name <- function(x, y, ...)
  # NULL
  #
  # So let's add the function definition back in
  funargs[1] <- paste(fun_name, "<-", funargs[1])

  # Combine our extracted roxygen and the function definition
  roxy_text <- paste(c(roxy, funargs), collapse = "\n")
  return(roxy_text)
}



#' has_docstring
#'
#' @description This function has been stolen from the docsting package.
#' It checks the function for roxygen type comments (any no order necessary)
#'
#' @param fun a function to document ( will error if no r oxygen comments in it)
#' @param fun_name defaults to a string of the function name, otherwise defines the name the documentaion file will be named
#' @import roxygen2
#' @return The function returns the text from r oxygen comments

has_docstring <- function(fun, fun_name = as.character(substitute(fun))){
  out <- docstring_to_roxygen(fun, fun_name, error = FALSE)
  return(!is.na(out))
}








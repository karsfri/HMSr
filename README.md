
<!-- README.md is generated from README.Rmd. Please edit that file -->

# HMSr

<!-- badges: start -->

<!-- badges: end -->

**NOTE: MOST OF THE FUNCTION HAVE NO PRACTICAL USE OUTSIDE
[HMS](https://www.hms.is/)**

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("karsfri/HMSr")
```

## Example

The default template in ggplot2 is readable, but ugly:

``` r
library(tidyverse)
#> -- Attaching packages ---------------------------------------------------------------------------------------------- tidyverse 1.3.0 --
#> v ggplot2 3.3.0.9000     v purrr   0.3.3     
#> v tibble  2.1.3          v dplyr   0.8.3     
#> v tidyr   1.0.0          v stringr 1.4.0     
#> v readr   1.3.1          v forcats 0.4.0
#> -- Conflicts ------------------------------------------------------------------------------------------------- tidyverse_conflicts() --
#> x dplyr::filter() masks stats::filter()
#> x dplyr::lag()    masks stats::lag()
library(lubridate)
#> 
#> Attaching package: 'lubridate'
#> The following object is masked from 'package:base':
#> 
#>     date
library(HMSr)


data("economics")

  economics %>%
    filter(date == lubridate::floor_date(date, "year"), year(date) > 2000) %>%
    gather(var, val, -date) %>%
    ggplot(aes(date, val, color = var)) +
    geom_col(width = 0.3) +
    geom_point() +
    labs(
      title = "Lollipops and stuff",
      subtitle = "With HMS colors",
      x = NULL,
      y = NULL,
      caption = "Source: None of your business :P"
    ) +
    facet_wrap(~var, scales = "free_y")
```

<img src="man/figures/README-example-1.png" width="100%" />

The *theme\_set\_hms()* function sets *theme\_hms* as the default theme,
along with default colors for some of the more popular geoms.

Notice also the helper function, *label\_isl()*.

``` r
theme_set_hms()

  economics %>%
    filter(date == lubridate::floor_date(date, "year"), year(date) > 2000) %>%
    gather(var, val, -date) %>%
    ggplot(aes(date, val, color = var)) +
    geom_col(width = 0.3) +
    geom_point() +
    theme_hms() +
    scale_color_manual(values = palette_dark) +
    scale_y_continuous(labels = label_isl()) +
    labs(
      title = "Lollipops and stuff",
      subtitle = "With HMS colors",
      x = NULL,
      y = NULL,
      caption = "Source: None of your business :P"
    ) +
    facet_wrap(~var, scales = "free_y")
```

<img src="man/figures/README-cars-1.png" width="100%" />

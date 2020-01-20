
<!-- README.md is generated from README.Rmd. Please edit that file -->

# HMSr

<!-- badges: start -->

<!-- badges: end -->

**NOTE: MOST OF THE FUNCTION HAVE NO PRACTICAL USE OUTSIDE
[HMS](https://www.hms.is/)**

This pacake will include:

  - **Graphical theme**
  - **Common helper functions**
      - Tidy seasonal adjustment with X13
  - **Tools for getting and handling data from the datawarehouse**
  - **functions to get external data**

## Installation

**NOTE: MIGHT NOT WORK IN MAC BECAUSE OF THE FOLLOWING CODE IN theme.R**

``` r
# Load fonts
  # grDevices::windowsFonts(Setimo = windowsFont("Setimo"))
  # grDevices::windowsFonts(SetimoLight = windowsFont("Setimo Light"))
```

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
remotes::install_github("karsfri/HMSr")
```

## Theme

**NOTE:** color palette will improve\! Waiting for more colors

The default template in ggplot2 is readable, but ugly:

``` r
library(tidyverse)
library(patchwork)
library(lubridate)
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
    subtitle = "With default colors :(",
    x = NULL,
    y = NULL,
    caption = "Source: None of your business :P"
  ) +
  facet_wrap(~var, scales = "free_y")
```

<img src="man/figures/README-unnamed-chunk-3-1.png" width="100%" />

The `theme_set_hms()` function sets `theme_hms` as the default theme,
along with default colors for some of the more popular geoms.

Notice also the helper function, `label_isl()`.

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
    subtitle = "With HMS colors :)",
    x = NULL,
    y = NULL,
    caption = "Source: None of your business :P"
  ) +
  facet_wrap(~var, scales = "free_y")
```

<img src="man/figures/README-unnamed-chunk-4-1.png" width="100%" />

### Palettes

**WAITING FOR PERMANENT PALETTES**

### Scales

### Caption strings

Strings for common sources to put in caption:

``` r
c(
cap_hms,
cap_hagstofa,
cap_hms_hagstofa,
cap_thjodskra,
cap_hms_thjodskra,
cap_sedlo,
cap_hms_sedlo
) %>% 
knitr::kable()
```

| x                                           |
| :------------------------------------------ |
| Heimild: Hagdeild HMS                       |
| Heimild: Hagstofa Íslands                   |
| Heimild: Hagstofa Íslands og hagdeild HMS   |
| Heimild: Þjóðskrá Íslands                   |
| Heimild: Þjóðskrá Íslands og hagdeild HMS   |
| Heimild: Seðlabanki Íslands                 |
| Heimild: Seðlabanki Íslands og hagdeild HMS |

## save functions

The functions `ggsave_png`, `ggsave_svg` and `ggsave_both` are thin
wrappers around `ggsave`, with default resolution and size set. There
are two commonly used length and width parameters in *HMS* documents,
and those are provided as objects and they have the following values in
cm:

``` r
c(
  width_narrow,
  width_wide,
  height_regular,
  height_full
) %>% 
  knitr::kable()
```

|    x |
| ---: |
|  8.5 |
| 18.0 |
|  9.0 |
| 20.0 |

## Seasonal adjustment

*NOT READY*

Group of functions that make X13-ARIMA seasonal adjustment easier on the
fly.

  - `seas_seasonally_adjusted()`
  - `seas_trend()`
  - `seas_seasonal_components()`
  - `seas_irregular()`
  - `seas_irregular()`

<!-- end list -->

``` r
# https://px.hagstofa.is/pxis/pxweb/is/Efnahagur/Efnahagur__utanrikisverslun__1_voruvidskipti__01_voruskipti/UTA06002.px/table/tableViewLayout1/?rxid=8966fb9b-6a92-41b6-8758-129d490bb573
trade <- read_hagstofan_alt("https://px.hagstofa.is:443/pxis/sq/8ad42406-35c1-442b-a556-1498992b56ed")
```

The data is different components of international trade:

``` r
trade %>% 
  head() %>% 
  knitr::kable()
```

| Mánuður | Útflutningur fob | Innflutningur fob | Innflutningur cif | Vöruviðskiptajöfnuður fob-fob | Vöruviðskiptajöfnuður fob-cif |
| :------ | ---------------: | ----------------: | ----------------: | ----------------------------: | ----------------------------: |
| 2010M01 |          38605.1 |           32927.7 |           35657.7 |                        5677.5 |                        2947.4 |
| 2010M02 |          44266.3 |           30393.2 |           33079.4 |                       13873.1 |                       11186.9 |
| 2010M03 |          52763.7 |           41325.0 |           44660.1 |                       11438.8 |                        8103.7 |
| 2010M04 |          41095.7 |           33791.0 |           36750.9 |                        7304.7 |                        4344.8 |
| 2010M05 |          52311.9 |           35690.6 |           39066.4 |                       16621.3 |                       13245.5 |
| 2010M06 |          50671.3 |           39247.5 |           42577.4 |                       11423.8 |                        8094.0 |

Seasonal adjustment for one group:

``` r
trade %>%
  mutate(Mánuður = lubriYYYYMM(Mánuður)) %>%
  ################# Magic :) #################################################
  mutate(
    `Útflutningur fob - Árstíðarleiðrétt` = seas_seasonally_adjusted(`Útflutningur fob`, Mánuður)
    ) %>%
  ##############################################################################
  select(Mánuður, `Útflutningur fob`, `Útflutningur fob - Árstíðarleiðrétt` ) %>%
  gather(var, val, -Mánuður) %>%
  ggplot(aes(Mánuður, val, color = var)) +
  geom_line()
```

<img src="man/figures/README-unnamed-chunk-9-1.png" width="100%" />

## Dates

The lubriyear converts numeric vector containing years to a date
variable at January first of the corrisponding year:

``` r
x <- tibble(year = 2010:2017)

x %>% 
  mutate(timi = lubriyear(year)) %>% 
  knitr::kable()
```

| year | timi       |
| ---: | :--------- |
| 2010 | 2010-01-01 |
| 2011 | 2011-01-01 |
| 2012 | 2012-01-01 |
| 2013 | 2013-01-01 |
| 2014 | 2014-01-01 |
| 2015 | 2015-01-01 |
| 2016 | 2016-01-01 |
| 2017 | 2017-01-01 |

It also has optional argument, month:

``` r
x %>% 
  mutate(
    month = rep_len(rep(1:12), 8),
    timi = lubriyear(year, month)
    )
```

    ## # A tibble: 8 x 3
    ##    year month timi      
    ##   <int> <int> <date>    
    ## 1  2010     1 2010-01-01
    ## 2  2011     2 2011-02-01
    ## 3  2012     3 2012-03-01
    ## 4  2013     4 2013-04-01
    ## 5  2014     5 2014-05-01
    ## 6  2015     6 2015-06-01
    ## 7  2016     7 2016-07-01
    ## 8  2017     8 2017-08-01

lubriYYYYMM works the same, but is made specially for the MMMMYY
variable from the datawarehouse (and some tables from hagstofan.is):

``` r
lubriYYYYMM("2017M03") %>% 
  knitr::kable()
```

| x          |
| :--------- |
| 2017-03-01 |

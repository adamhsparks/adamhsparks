---
title: Fetch NASA POWER Data Using a Data Frame of Locations
author: Adam Sparks
date: '2024-06-13'
slug: fetch-nasa-power-data-using-a-data-frame-of-locations
categories: []
tags: [R, nasapower]
comments: no
images: ~
---

Usually when you use [{nasapower}](https://ropensci.github.io/nasapower/index.html) to fetch data, you use a vector of longitude and latitude locations to make requests from the API.
But if you have coordinates in a data frame, *e.g.*, sample locations with sampling dates that you want POWER weather data for, it may not be as intuitive.
Here's a quick illustration how you can use a data frame object to feed into [`get_power()`](https://ropensci.github.io/nasapower/reference/get_power.html) and fetch relative humidity data that way using [{purrr}](https://purrr.tidyverse.org/) and [{dplyr}](https://dplyr.tidyverse.org/).


``` r
library("nasapower")
library("purrr")
library("dplyr")
```

```
## 
## Attaching package: 'dplyr'
```

```
## The following objects are masked from 'package:stats':
## 
##     filter, lag
```

```
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

``` r
df <- data.frame(
  stringsAsFactors = FALSE,
  lon = c(151.81, 112.5, 115.5),
  lat = c(-27.48, -55.5, -50.5),
  date = c("3/3/2023", "5/12/2023", "1/3/2024")
)

xy_list <-
  as.list(as.data.frame(t(df[, 1:2]),
                        stringsAsFactors = FALSE,
                        row.names = NA))

bind_rows(
  map2(
    .x = xy_list,
    .y = df$date,
    .f = get_power,
    community = "ag",
    pars = "RH2M",
    temporal_api = "daily",
  )
)
```

```
## NASA/POWER CERES/MERRA2 Native Resolution Daily Data  
##  Dates (month/day/year): 03/03/2023 through 03/03/2023  
##  Location: Latitude  -27.48   Longitude 151.81  
##  Elevation from MERRA-2: Average for 0.5 x 0.625 degree lat/lon region = 442.77 meters 
##  The value for missing source data that cannot be computed or is outside of the sources availability range: NA  
##  Parameter(s):  
##  
##  Parameters: 
##  RH2M     MERRA-2 Relative Humidity at 2 Meters (%)  
##  
## # A tibble: 3 × 8
##     LON   LAT  YEAR    MM    DD   DOY YYYYMMDD    RH2M
##   <dbl> <dbl> <dbl> <int> <int> <int> <date>     <dbl>
## 1  152. -27.5  2023     3     3    62 2023-03-03  64.6
## 2  112. -55.5  2023    12     5   339 2023-12-05  90.5
## 3  116. -50.5  2024     3     1    61 2024-03-01  85.6
```

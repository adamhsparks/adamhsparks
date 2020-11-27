---
title: "Linear modelling of soil temperature effects on root lesion nematode population densities in R"
author:
- name: Adam H. Sparks
  affiliation: University of Southern Queensland, Centre for Crop Health, Toowoomba, Qld, AU
- name: John P. Thompson
  affiliation: University of Southern Queensland, Centre for Crop Health, Toowoomba, Qld, AU
output:
  html_document:
    keep_md: yes
    df_print: paged
knit: (function(inputFile, encoding) {
    rmarkdown::render(inputFile, encoding = encoding, output_dir = "../")
  })
bibliography: bibliography.bib
csl: phytopathology.csl
params:
  output_dir: "../"
---



Adam H. Sparks and John P. Thompson
University of Southern Queensland, Centre for Crop Health, Toowoomba, Qld, AU

[![DOI](https://zenodo.org/badge/119438897.svg)](https://zenodo.org/badge/latestdoi/119438897)
[![](https://img.shields.io/badge/OPP-Peer%20Reviewed-brightgreen.svg)](https://github.com/openplantpathology/contributions/issues/1)
[![GitHub version](https://img.shields.io/github/release/adamhsparks/Modelling_Nematode_Populations.svg)](https://github.com/adamhsparks/Modelling_Nematode_Populations)

# Introduction

_Pratylenchus thornei_, the root-lesion nematode, is widely distributed in wheat
(_Triticum aestivum_) growing areas of many countries and is of particular
concern in sub-tropical environments [@THOMPSON2015]. These nematodes penetrate
roots to  feed and reproduce in the root cortex leading to loss of root
function, which affects nutrient and water uptake of nutrients and water causing
nutrient deficiency and water stress [@THOMPSON2015].

In the original paper the population response of _P. thornei_ in Queensland,
Australia wheat to temperature is modelled using a linear and quadratic
equations. The study aimed to investigate the effects of soil profile
temperatures after different sowing dates on reproduction of the nematodes in
susceptible and moderately resistant wheat cultivars in the subtropical grain
region of eastern Australia. This document recreates the models for population
densities of _P. thornei_ as described in the original paper.

## Objectives

There are two types of models described in the paper, the first model is a
linear model used to describe the unplanted control and two quadratic models fit
Gatcher (Susceptible) and GS50a (Moderately Resistant) wheat cultivars. For a
more detailed discussion on fitting plant disease models in R, please see the
"[Linear Regression](http://www.apsnet.org/edcenter/advanced/topics/EcologyAndEpidemiologyInR/DiseaseProgress/Pages/LinearRegression.aspx)" module in the "Ecology and Epidemiology
in R" documents available in the American Phytopathological Society's (APS)
Education Center. For an even more in-depth discussion on linear models in R,
how to fit and how to interpret the diagnostics that R provides the reader
should refer to Faraway [-@FARAWAY2002].

This post will illustrate how to fit the original linear and quadratic models
using the original data in R [@R2017].

# Packages

Using the **`tidyverse`**, [-@TIDYVERSE2017] package simplifies the libraries
used in this work. It is a collection of packages designed to work together for
data science, <https://www.tidyverse.org/>. The **`tidyverse`** includes, 
**`readr`** [-@READR2017], used to import the data; **`tidyr`**
[-@TIDYR2018], used to format the data; **`dplyr`** [-@DPLYR2017], used to
subset the data; and **`ggplot2`** [-@GGPLOT22009], used for visualising the
data and model fits. **`viridis`** [-@VIRIDIS2018] is a selection of colour
pallets that are widely accessible for people with colour-blindness and printing
in black and white.

The following code chunk checks first to see if you have **`tidyverse`** and
**`viridis`** installed, if not, it will automatically install them and then
load them.


```r
if (!require(tidyverse)) {
  install.packages("tidyverse",
                   repos = c(CRAN = "https://cloud.r-project.org/"))
  library(tidyverse)
}

if (!require(viridis)) {
  install.packages("viridis",
                   repos = c(CRAN = "https://cloud.r-project.org/"))
  library(viridis)
}
```

# Data Wrangling

The data are located in the `data` sub-folder. Import the data using
`read_csv()` function from **`readr`**  and view them.


```r
nema <- read_csv("data/Nematode_Data.csv")

nema
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["Weeks"],"name":[1],"type":["dbl"],"align":["right"]},{"label":["Days"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["Temperature"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["Degree_days"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["Unplanted"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["Gatcher"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["GS50a"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["Potam"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["Suneca"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"8","2":"56","3":"15.0","4":"280","5":"5.748","6":"6.773","7":"6.691","8":"7.613","9":"6.703"},{"1":"8","2":"56","3":"20.0","4":"560","5":"5.915","6":"9.513","7":"7.420","8":"9.285","9":"9.121"},{"1":"8","2":"56","3":"22.5","4":"700","5":"6.381","6":"9.956","7":"8.214","8":"9.024","9":"10.012"},{"1":"8","2":"56","3":"25.0","4":"840","5":"6.510","6":"9.354","7":"8.254","8":"9.732","9":"9.202"},{"1":"10","2":"70","3":"15.0","4":"350","5":"5.847","6":"7.435","7":"6.043","8":"5.972","9":"6.846"},{"1":"10","2":"70","3":"20.0","4":"700","5":"6.157","6":"10.338","7":"8.915","8":"10.284","9":"10.175"},{"1":"10","2":"70","3":"22.5","4":"875","5":"6.191","6":"10.423","7":"9.183","8":"10.691","9":"10.075"},{"1":"10","2":"70","3":"25.0","4":"1050","5":"6.364","6":"10.580","7":"9.045","8":"10.487","9":"10.344"},{"1":"12","2":"84","3":"15.0","4":"420","5":"5.755","6":"9.926","7":"8.187","8":"8.745","9":"9.573"},{"1":"12","2":"84","3":"20.0","4":"840","5":"6.978","6":"11.723","7":"9.852","8":"11.334","9":"11.684"},{"1":"12","2":"84","3":"22.5","4":"1050","5":"6.382","6":"12.272","7":"10.297","8":"12.118","9":"11.359"},{"1":"12","2":"84","3":"25.0","4":"1260","5":"6.759","6":"11.803","7":"10.115","8":"12.065","9":"11.487"},{"1":"14","2":"98","3":"15.0","4":"490","5":"5.754","6":"10.269","7":"8.232","8":"10.014","9":"9.775"},{"1":"14","2":"98","3":"20.0","4":"980","5":"6.958","6":"11.840","7":"10.141","8":"11.882","9":"11.633"},{"1":"14","2":"98","3":"22.5","4":"1225","5":"7.305","6":"13.101","7":"10.015","8":"12.440","9":"12.731"},{"1":"14","2":"98","3":"25.0","4":"1470","5":"7.509","6":"13.192","7":"11.075","8":"12.453","9":"12.514"},{"1":"16","2":"112","3":"15.0","4":"560","5":"5.892","6":"10.824","7":"9.352","8":"10.271","9":"10.279"},{"1":"16","2":"112","3":"20.0","4":"1120","5":"7.454","6":"12.591","7":"10.004","8":"13.006","9":"13.128"},{"1":"16","2":"112","3":"22.5","4":"1400","5":"7.144","6":"13.532","7":"11.350","8":"13.009","9":"13.250"},{"1":"16","2":"112","3":"25.0","4":"1680","5":"8.084","6":"13.032","7":"11.598","8":"12.653","9":"12.995"},{"1":"18","2":"126","3":"15.0","4":"630","5":"7.216","6":"11.168","7":"9.357","8":"10.892","9":"10.534"},{"1":"18","2":"126","3":"20.0","4":"1260","5":"6.957","6":"13.417","7":"11.005","8":"12.209","9":"12.998"},{"1":"18","2":"126","3":"22.5","4":"1575","5":"7.549","6":"13.167","7":"10.687","8":"12.640","9":"13.610"},{"1":"18","2":"126","3":"25.0","4":"1890","5":"7.202","6":"12.913","7":"11.068","8":"12.458","9":"13.472"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

```r
nrow(nema)
```

```
## [1] 24
```

### Description of Fields in the Data

There are nine columns in the `nema` data described here in the following table.

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;border-bottom: 0;">
 <thead>
  <tr>
   <th style="text-align:left;"> Field </th>
   <th style="text-align:left;"> Data Description </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Weeks </td>
   <td style="text-align:left;"> Number of weeks after wheat sowing </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Days </td>
   <td style="text-align:left;"> Number of days after wheat sowing </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Temperature </td>
   <td style="text-align:left;"> Temperature (˚C) treatment </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Degree_Days </td>
   <td style="text-align:left;"> Average thermal time degree days above 10 ˚C for four soil depths
    (8, 15, 30 and 60 cm) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Unplanted </td>
   <td style="text-align:left;"> Log<sup>*</sup>, `log()`, nematode population in
    the control treatment with no wheat planted </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Gatcher </td>
   <td style="text-align:left;"> Log<sup>*</sup>, `log()`, nematode population in a
    susceptible wheat cultivar </td>
  </tr>
  <tr>
   <td style="text-align:left;"> GS50a </td>
   <td style="text-align:left;"> Log<sup>*</sup>, `log()`, nematode population in a
    moderately resistant wheat cultivar </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Potam </td>
   <td style="text-align:left;"> Log<sup>*</sup>, `log()`, nematode population in a
    susceptible wheat cultivar </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Suneca </td>
   <td style="text-align:left;"> Log<sup>*</sup>, `log()`, nematode population in a
    susceptible wheat cultivar </td>
  </tr>
</tbody>
<tfoot><tr><td style="padding: 0; " colspan="100%">
<sup>*</sup> For an exploration into the reasons why the data were transformed<br>              using the natural log `log()`, see the<br>              [Exploring Why the Data Were Log Transformed] in the<br>              [Bonus Material] section</td></tr></tfoot>
</table>

### Wide to Long Data

You can see that each of the varieties have their own column in the original
data format, this is commonly called wide data. Wide data are commonly found in
spreadsheets but do not lend themselves easily to data analysis, modelling and
visualisation. To make it easier to do these things it is common to convert the
data from wide to long format, commonly referred to as tidying, when using R.
The advantage of a tidy dataset is that it is easy to manipulate, model and
visualize, and always has a specific structure where each variable is a column,
each observation is a row, and each type of observational unit is a table
[@TIDY-DATA2014].

In order to use **`ggplot2`** for visualising the data, they need to be
converted from wide to long. Using `gather()` from the **`tidyr`** package to
convert from wide to long format where the varieties are all listed in a single
column, `Variety`.


```r
nema_long <- nema %>% gather(Variety, Log_pop, Unplanted:Suneca)

nema_long
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["Weeks"],"name":[1],"type":["dbl"],"align":["right"]},{"label":["Days"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["Temperature"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["Degree_days"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["Variety"],"name":[5],"type":["chr"],"align":["left"]},{"label":["Log_pop"],"name":[6],"type":["dbl"],"align":["right"]}],"data":[{"1":"8","2":"56","3":"15.0","4":"280","5":"Unplanted","6":"5.748"},{"1":"8","2":"56","3":"20.0","4":"560","5":"Unplanted","6":"5.915"},{"1":"8","2":"56","3":"22.5","4":"700","5":"Unplanted","6":"6.381"},{"1":"8","2":"56","3":"25.0","4":"840","5":"Unplanted","6":"6.510"},{"1":"10","2":"70","3":"15.0","4":"350","5":"Unplanted","6":"5.847"},{"1":"10","2":"70","3":"20.0","4":"700","5":"Unplanted","6":"6.157"},{"1":"10","2":"70","3":"22.5","4":"875","5":"Unplanted","6":"6.191"},{"1":"10","2":"70","3":"25.0","4":"1050","5":"Unplanted","6":"6.364"},{"1":"12","2":"84","3":"15.0","4":"420","5":"Unplanted","6":"5.755"},{"1":"12","2":"84","3":"20.0","4":"840","5":"Unplanted","6":"6.978"},{"1":"12","2":"84","3":"22.5","4":"1050","5":"Unplanted","6":"6.382"},{"1":"12","2":"84","3":"25.0","4":"1260","5":"Unplanted","6":"6.759"},{"1":"14","2":"98","3":"15.0","4":"490","5":"Unplanted","6":"5.754"},{"1":"14","2":"98","3":"20.0","4":"980","5":"Unplanted","6":"6.958"},{"1":"14","2":"98","3":"22.5","4":"1225","5":"Unplanted","6":"7.305"},{"1":"14","2":"98","3":"25.0","4":"1470","5":"Unplanted","6":"7.509"},{"1":"16","2":"112","3":"15.0","4":"560","5":"Unplanted","6":"5.892"},{"1":"16","2":"112","3":"20.0","4":"1120","5":"Unplanted","6":"7.454"},{"1":"16","2":"112","3":"22.5","4":"1400","5":"Unplanted","6":"7.144"},{"1":"16","2":"112","3":"25.0","4":"1680","5":"Unplanted","6":"8.084"},{"1":"18","2":"126","3":"15.0","4":"630","5":"Unplanted","6":"7.216"},{"1":"18","2":"126","3":"20.0","4":"1260","5":"Unplanted","6":"6.957"},{"1":"18","2":"126","3":"22.5","4":"1575","5":"Unplanted","6":"7.549"},{"1":"18","2":"126","3":"25.0","4":"1890","5":"Unplanted","6":"7.202"},{"1":"8","2":"56","3":"15.0","4":"280","5":"Gatcher","6":"6.773"},{"1":"8","2":"56","3":"20.0","4":"560","5":"Gatcher","6":"9.513"},{"1":"8","2":"56","3":"22.5","4":"700","5":"Gatcher","6":"9.956"},{"1":"8","2":"56","3":"25.0","4":"840","5":"Gatcher","6":"9.354"},{"1":"10","2":"70","3":"15.0","4":"350","5":"Gatcher","6":"7.435"},{"1":"10","2":"70","3":"20.0","4":"700","5":"Gatcher","6":"10.338"},{"1":"10","2":"70","3":"22.5","4":"875","5":"Gatcher","6":"10.423"},{"1":"10","2":"70","3":"25.0","4":"1050","5":"Gatcher","6":"10.580"},{"1":"12","2":"84","3":"15.0","4":"420","5":"Gatcher","6":"9.926"},{"1":"12","2":"84","3":"20.0","4":"840","5":"Gatcher","6":"11.723"},{"1":"12","2":"84","3":"22.5","4":"1050","5":"Gatcher","6":"12.272"},{"1":"12","2":"84","3":"25.0","4":"1260","5":"Gatcher","6":"11.803"},{"1":"14","2":"98","3":"15.0","4":"490","5":"Gatcher","6":"10.269"},{"1":"14","2":"98","3":"20.0","4":"980","5":"Gatcher","6":"11.840"},{"1":"14","2":"98","3":"22.5","4":"1225","5":"Gatcher","6":"13.101"},{"1":"14","2":"98","3":"25.0","4":"1470","5":"Gatcher","6":"13.192"},{"1":"16","2":"112","3":"15.0","4":"560","5":"Gatcher","6":"10.824"},{"1":"16","2":"112","3":"20.0","4":"1120","5":"Gatcher","6":"12.591"},{"1":"16","2":"112","3":"22.5","4":"1400","5":"Gatcher","6":"13.532"},{"1":"16","2":"112","3":"25.0","4":"1680","5":"Gatcher","6":"13.032"},{"1":"18","2":"126","3":"15.0","4":"630","5":"Gatcher","6":"11.168"},{"1":"18","2":"126","3":"20.0","4":"1260","5":"Gatcher","6":"13.417"},{"1":"18","2":"126","3":"22.5","4":"1575","5":"Gatcher","6":"13.167"},{"1":"18","2":"126","3":"25.0","4":"1890","5":"Gatcher","6":"12.913"},{"1":"8","2":"56","3":"15.0","4":"280","5":"GS50a","6":"6.691"},{"1":"8","2":"56","3":"20.0","4":"560","5":"GS50a","6":"7.420"},{"1":"8","2":"56","3":"22.5","4":"700","5":"GS50a","6":"8.214"},{"1":"8","2":"56","3":"25.0","4":"840","5":"GS50a","6":"8.254"},{"1":"10","2":"70","3":"15.0","4":"350","5":"GS50a","6":"6.043"},{"1":"10","2":"70","3":"20.0","4":"700","5":"GS50a","6":"8.915"},{"1":"10","2":"70","3":"22.5","4":"875","5":"GS50a","6":"9.183"},{"1":"10","2":"70","3":"25.0","4":"1050","5":"GS50a","6":"9.045"},{"1":"12","2":"84","3":"15.0","4":"420","5":"GS50a","6":"8.187"},{"1":"12","2":"84","3":"20.0","4":"840","5":"GS50a","6":"9.852"},{"1":"12","2":"84","3":"22.5","4":"1050","5":"GS50a","6":"10.297"},{"1":"12","2":"84","3":"25.0","4":"1260","5":"GS50a","6":"10.115"},{"1":"14","2":"98","3":"15.0","4":"490","5":"GS50a","6":"8.232"},{"1":"14","2":"98","3":"20.0","4":"980","5":"GS50a","6":"10.141"},{"1":"14","2":"98","3":"22.5","4":"1225","5":"GS50a","6":"10.015"},{"1":"14","2":"98","3":"25.0","4":"1470","5":"GS50a","6":"11.075"},{"1":"16","2":"112","3":"15.0","4":"560","5":"GS50a","6":"9.352"},{"1":"16","2":"112","3":"20.0","4":"1120","5":"GS50a","6":"10.004"},{"1":"16","2":"112","3":"22.5","4":"1400","5":"GS50a","6":"11.350"},{"1":"16","2":"112","3":"25.0","4":"1680","5":"GS50a","6":"11.598"},{"1":"18","2":"126","3":"15.0","4":"630","5":"GS50a","6":"9.357"},{"1":"18","2":"126","3":"20.0","4":"1260","5":"GS50a","6":"11.005"},{"1":"18","2":"126","3":"22.5","4":"1575","5":"GS50a","6":"10.687"},{"1":"18","2":"126","3":"25.0","4":"1890","5":"GS50a","6":"11.068"},{"1":"8","2":"56","3":"15.0","4":"280","5":"Potam","6":"7.613"},{"1":"8","2":"56","3":"20.0","4":"560","5":"Potam","6":"9.285"},{"1":"8","2":"56","3":"22.5","4":"700","5":"Potam","6":"9.024"},{"1":"8","2":"56","3":"25.0","4":"840","5":"Potam","6":"9.732"},{"1":"10","2":"70","3":"15.0","4":"350","5":"Potam","6":"5.972"},{"1":"10","2":"70","3":"20.0","4":"700","5":"Potam","6":"10.284"},{"1":"10","2":"70","3":"22.5","4":"875","5":"Potam","6":"10.691"},{"1":"10","2":"70","3":"25.0","4":"1050","5":"Potam","6":"10.487"},{"1":"12","2":"84","3":"15.0","4":"420","5":"Potam","6":"8.745"},{"1":"12","2":"84","3":"20.0","4":"840","5":"Potam","6":"11.334"},{"1":"12","2":"84","3":"22.5","4":"1050","5":"Potam","6":"12.118"},{"1":"12","2":"84","3":"25.0","4":"1260","5":"Potam","6":"12.065"},{"1":"14","2":"98","3":"15.0","4":"490","5":"Potam","6":"10.014"},{"1":"14","2":"98","3":"20.0","4":"980","5":"Potam","6":"11.882"},{"1":"14","2":"98","3":"22.5","4":"1225","5":"Potam","6":"12.440"},{"1":"14","2":"98","3":"25.0","4":"1470","5":"Potam","6":"12.453"},{"1":"16","2":"112","3":"15.0","4":"560","5":"Potam","6":"10.271"},{"1":"16","2":"112","3":"20.0","4":"1120","5":"Potam","6":"13.006"},{"1":"16","2":"112","3":"22.5","4":"1400","5":"Potam","6":"13.009"},{"1":"16","2":"112","3":"25.0","4":"1680","5":"Potam","6":"12.653"},{"1":"18","2":"126","3":"15.0","4":"630","5":"Potam","6":"10.892"},{"1":"18","2":"126","3":"20.0","4":"1260","5":"Potam","6":"12.209"},{"1":"18","2":"126","3":"22.5","4":"1575","5":"Potam","6":"12.640"},{"1":"18","2":"126","3":"25.0","4":"1890","5":"Potam","6":"12.458"},{"1":"8","2":"56","3":"15.0","4":"280","5":"Suneca","6":"6.703"},{"1":"8","2":"56","3":"20.0","4":"560","5":"Suneca","6":"9.121"},{"1":"8","2":"56","3":"22.5","4":"700","5":"Suneca","6":"10.012"},{"1":"8","2":"56","3":"25.0","4":"840","5":"Suneca","6":"9.202"},{"1":"10","2":"70","3":"15.0","4":"350","5":"Suneca","6":"6.846"},{"1":"10","2":"70","3":"20.0","4":"700","5":"Suneca","6":"10.175"},{"1":"10","2":"70","3":"22.5","4":"875","5":"Suneca","6":"10.075"},{"1":"10","2":"70","3":"25.0","4":"1050","5":"Suneca","6":"10.344"},{"1":"12","2":"84","3":"15.0","4":"420","5":"Suneca","6":"9.573"},{"1":"12","2":"84","3":"20.0","4":"840","5":"Suneca","6":"11.684"},{"1":"12","2":"84","3":"22.5","4":"1050","5":"Suneca","6":"11.359"},{"1":"12","2":"84","3":"25.0","4":"1260","5":"Suneca","6":"11.487"},{"1":"14","2":"98","3":"15.0","4":"490","5":"Suneca","6":"9.775"},{"1":"14","2":"98","3":"20.0","4":"980","5":"Suneca","6":"11.633"},{"1":"14","2":"98","3":"22.5","4":"1225","5":"Suneca","6":"12.731"},{"1":"14","2":"98","3":"25.0","4":"1470","5":"Suneca","6":"12.514"},{"1":"16","2":"112","3":"15.0","4":"560","5":"Suneca","6":"10.279"},{"1":"16","2":"112","3":"20.0","4":"1120","5":"Suneca","6":"13.128"},{"1":"16","2":"112","3":"22.5","4":"1400","5":"Suneca","6":"13.250"},{"1":"16","2":"112","3":"25.0","4":"1680","5":"Suneca","6":"12.995"},{"1":"18","2":"126","3":"15.0","4":"630","5":"Suneca","6":"10.534"},{"1":"18","2":"126","3":"20.0","4":"1260","5":"Suneca","6":"12.998"},{"1":"18","2":"126","3":"22.5","4":"1575","5":"Suneca","6":"13.610"},{"1":"18","2":"126","3":"25.0","4":"1890","5":"Suneca","6":"13.472"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

```r
nrow(nema_long)
```

```
## [1] 120
```

As we see, the original `nema` data had only 24 rows and the long
format of the data have 120 rows now.

# Data Visualisation

Now that the data are in the format that **`ggplot2`** uses, take a look at
the data first to see what it looks like. Here we fit a smoothed line for each
variety's nematode population to the raw data. The individual temperature
treatments are shown here by shape, the variety by colour.


```r
ggplot(
  nema_long,
  aes(
    x = Degree_days,
    y = Log_pop,
    colour = Temperature,
    group = Variety
  )
) +
  geom_point() +
  geom_smooth(colour = "grey",
              se = FALSE,
              alpha = 0.5) +
  ylab(expression(paste("ln(",
                        italic("P. thornei"),
                        "/kg soil) + 1"),
                  sep = "")) +
  xlab("Thermal Time (˚C Days Above 10˚C)") +
  theme_minimal() +
  scale_colour_viridis("Temperature") +
  facet_wrap( ~ Variety, ncol = 2)
```

![](/Users/adamsparks/Sources/GitHub/Adam/adamhsparks/content/blog/Fitting_Nematode_Models_files/figure-html/raw_data_scatterplots-1.png)<!-- -->

# Modelling

## Unplanted Model

The paper uses a linear model for the unplanted control. Here we will write a
function to use in modelling the unplanted population data. I have wrapped the
model in a function which makes it pipe-able, `%>%` and has other advantages
when it comes to fitting the same model to several sets of data.

In the linear equation for the Unplanted control treatment, the rate of
population increase can be expressed as:

$$y = y_0 + rt$$

Where $y_0$ is the initial population, $r$ is the rate of change and $t$
equal time.

### Fitting a Linear Model


```r
linear_model <- function(df) {
  lm(Log_pop ~ Degree_days,
     data = df)
}
```

Now check the model fit, using `filter()` from **`dplyr`** to select only
Unplanted data from the data set for the model and fit the linear model to the
data.


```r
unplanted_model <- nema_long %>%
  filter(Variety == "Unplanted") %>%
  linear_model()
```

Using `par(mfrow = c(2, 2))` creates a four-panel graph rather than four
individual graphs, which the next function will create by default.

Using the `plot()` function with any `lm()` object will create four diagnostic
plots for your inspection.


```r
par(mfrow = c(2, 2))
plot(unplanted_model)
```

![](/Users/adamsparks/Sources/GitHub/Adam/adamhsparks/content/blog/Fitting_Nematode_Models_files/figure-html/plot_model-1.png)<!-- -->

These plots do not appear to indicate anything amiss as one would hope for from
the models that have already been published. If you are unfamiliar with how to
interpret these diagnostic plots see [Interpreting Linear Models in R] in the
[Further Reading] section.

Using the `summary()` function displays information about the model fit. If you
are unfamiliar with how to read and interpret the output of `summary()` for a
linear model, please refer to [Interpreting Linear Models in R] in the
[Further Reading] section for references that go into more detail on this matter.


```r
summary(unplanted_model)
```

```
## 
## Call:
## lm(formula = Log_pop ~ Degree_days, data = df)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -0.6605 -0.2581 -0.0568  0.2112  0.9851 
## 
## Coefficients:
##             Estimate Std. Error t value             Pr(>|t|)    
## (Intercept) 5.415064   0.192973    28.1 < 0.0000000000000002 ***
## Degree_days 0.001295   0.000182     7.1            0.0000004 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.385 on 22 degrees of freedom
## Multiple R-squared:  0.696,	Adjusted R-squared:  0.683 
## F-statistic: 50.5 on 1 and 22 DF,  p-value: 0.000000401
```

From the original paper, the $R^2$ value of the unplanted linear model was
0.7, we can see here that agrees:
0.7. In the original paper,
$P$ < 0.001, R reports $p-value:$ 
0, which also agrees.

#### Visualising the Model Fit to the Data

Using **`ggplot2`**'s `geom_smooth()` we can fit the same model above and graph
the resulting line.


```r
nema_long %>%
  group_by(Variety) %>%
  filter(Variety == "Unplanted") %>%
  ggplot(aes(
    x = Degree_days,
    y = Log_pop,
    colour = Temperature
  )) +
  geom_point() +
  geom_smooth(method = "lm",
              formula = y ~ x,
              size = 1,
              se = FALSE,
              colour = "grey",
              alpha = 0.5) +
  ylab(expression(paste("ln(",
                        italic("P. thornei"),
                        "/kg soil) + 1"),
                  sep = "")) +
  xlab("Thermal Time (˚C Days Above 10˚C)") +
  theme_minimal() +
  scale_colour_viridis("Temperature") +
  ggtitle("Unplanted Linear Model")
```

![](/Users/adamsparks/Sources/GitHub/Adam/adamhsparks/content/blog/Fitting_Nematode_Models_files/figure-html/visualise_linear-1.png)<!-- -->

## Quadratic Models

In the original paper, the quadratic model best described Gatcher and GS50a
data, which are fit here.


```r
quadratic_model <- function(df) {
  lm(Log_pop ~ Degree_days + I(Degree_days^2),
      data = df)
}
```

### Susceptible Varieties

Gatcher, Potam and Suneca all have very similar curves, here Gatcher is used to
fit a quadratic model as in the original paper following the same methods as
above for the linear model.


```r
s_model <- nema_long %>%
  filter(Variety == "Gatcher") %>% 
  quadratic_model()

par(mfrow = c(2, 2))
plot(s_model)
```

![](/Users/adamsparks/Sources/GitHub/Adam/adamhsparks/content/blog/Fitting_Nematode_Models_files/figure-html/susceptible_model-1.png)<!-- -->

```r
summary(s_model)
```

```
## 
## Call:
## lm(formula = Log_pop ~ Degree_days + I(Degree_days^2), data = df)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -1.807 -0.589  0.073  0.582  1.149 
## 
## Coefficients:
##                      Estimate   Std. Error t value  Pr(>|t|)    
## (Intercept)       5.476104048  0.904332841    6.06 0.0000052 ***
## Degree_days       0.008961212  0.001909375    4.69   0.00012 ***
## I(Degree_days^2) -0.000002612  0.000000901   -2.90   0.00858 ** 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.863 on 21 degrees of freedom
## Multiple R-squared:   0.8,	Adjusted R-squared:  0.781 
## F-statistic:   42 on 2 and 21 DF,  p-value: 0.0000000462
```

From the original paper, the $R^2$ value of Gatcher's quadratic model was 0.80,
we can see here that agrees: 0.8. In the
original paper, $P$ < 0.001, R reports $p-value:$
0.0001, which also agrees.

#### Visualise Susceptible Variety Model

The model visualisation is the same for the quadratic models as the linear
model, however you will note that the line has a downward curve at higher
temperatures.


```r
nema_long %>%
  group_by(Variety) %>%
  filter(Variety == "Gatcher") %>%
  ggplot(aes(
    x = Degree_days,
    y = Log_pop,
    colour = Temperature,
  )) +
  geom_point() +
  geom_smooth(method = "lm",
              formula = y ~ x + I(x^2),
              size = 1,
              se = FALSE,
              colour = "grey",
              alpha = 0.5) +
  ylab(expression(paste("ln(",
                        italic("P. thornei"),
                        "/kg soil) + 1"),
                  sep = "")) +
  xlab("Thermal Time (˚C Days Above 10˚C)") +
  theme_minimal() +
  scale_colour_viridis("Temperature") +
  ggtitle("Gatcher Quadratic Model")
```

![](/Users/adamsparks/Sources/GitHub/Adam/adamhsparks/content/blog/Fitting_Nematode_Models_files/figure-html/visualise_s_model-1.png)<!-- -->

### Moderately Resistant Cultiver

GS50a, moderately resistant to _P. thornei_, also fits a quadratic model but the
coefficients are slightly different due to different responses to the variety
and temperature.


```r
mr_model <- nema_long %>%
  filter(Variety == "GS50a") %>%
  quadratic_model()

par(mfrow = c(2, 2))
plot(mr_model)
```

![](/Users/adamsparks/Sources/GitHub/Adam/adamhsparks/content/blog/Fitting_Nematode_Models_files/figure-html/moderately_resistant_model-1.png)<!-- -->

```r
summary(mr_model)
```

```
## 
## Call:
## lm(formula = Log_pop ~ Degree_days + I(Degree_days^2), data = df)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -1.1128 -0.3985  0.0289  0.4549  1.1860 
## 
## Coefficients:
##                      Estimate   Std. Error t value   Pr(>|t|)    
## (Intercept)       5.156893818  0.677913227    7.61 0.00000018 ***
## Degree_days       0.006274415  0.001431321    4.38    0.00026 ***
## I(Degree_days^2) -0.000001609  0.000000675   -2.38    0.02672 *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.647 on 21 degrees of freedom
## Multiple R-squared:  0.823,	Adjusted R-squared:  0.806 
## F-statistic: 48.9 on 2 and 21 DF,  p-value: 0.0000000125
```

From the original paper, the $R^2$ value of GS50a's quadratic model was 0.82,
we can see here that agrees: 0.82. In the
original paper, $P$ < 0.001, R reports $p-value:$
0.0003, which also agrees.

#### Visualising the Model Fit to the Data


```r
nema_long %>%
  group_by(Variety) %>%
  filter(Variety == "GS50a") %>%
  ggplot(aes(
    x = Degree_days,
    y = Log_pop,
    colour = Temperature,
  )) +
  geom_point() +
  geom_smooth(method = "lm",
              formula = y ~ x + I(x^2),
              size = 1,
              se = FALSE,
              colour = "grey",
              alpha = 0.5) +
  ylab(expression(paste("ln(",
                        italic("P. thornei"),
                        "/kg soil) + 1"),
                  sep = "")) +
  xlab("Thermal Time (˚C Days Above 10˚C)") +
  theme_minimal() +
  scale_colour_viridis("Temperature") +
  ggtitle("GS50a Quadratic Model")
```

![](/Users/adamsparks/Sources/GitHub/Adam/adamhsparks/content/blog/Fitting_Nematode_Models_files/figure-html/visualise_mr_model-1.png)<!-- -->

# Discussion and Conclusions

As in the original paper, the model equations can be derived from these models
as well. The derived regression equations are:

Gatcher (Susceptible):
$$ln(P. thornei + 1) = -0.000003(0.0000009)T^2 + 0.009(0.0019)T + 5.4671(0.904)$$

GS50a (Moderately Resistant):
$$ln(P. thornei + 1) = -0.000002(0.0000007)T^2 + 0.0063(0.0014)T + 5.1559(0.678)$$

Unplanted Control: $$ln(P. thornei + 1) = 0.0013(0.00018)T + 5.4151(0.193)$$

Refer back to the `summary()` outputs for each of the models for the coefficient
values and $R^2$ values, which match those reported in the original paper where
the models were fit with Genstat.

Gatcher and GS50a have similar phenologies, but differ in resistance to root
lesion nematodes, making the model comparisons a reasonable objective. The
original paper goes on to test the effect of sowing date based on degree days.
[@THOMPSON2015] reported a 61% increase in yield on average from sowing
the susceptible, intolerant cultivar Gatcher at the end of May than sowing it
in the third week of June. By June the soil temperatures and nematode
populations were both greater, leading to lower wheat yield. The effects were
less pronounced in the moderately resistant cultivar, GS50a, but were similar
with a reduction in nematode population densities occurring due to earlier
planting.

The models illustrated here for Gatcher and GS50a were able to accurately
reflect the changes in nematode population as a result of degree days, which
affected the nematodes' ability to damage the crop and reduce yield
[@THOMPSON2015].

# Bonus Material

## Exploring Why the Data Were Log Transformed

In the paper the the natural log, `ln() +1`, of the nematode population counts
were used to fit the models. Here we will explore a bit further why this was
necessary.

_A note about using `log() + 1` rather than just `log()`. This is necessary with
these data to avoid taking `log(0)`. Try it in R to see what happens if you are
not familiar._

First, plot the data for each of the four temperatures and the four varieties,
plus the unplanted control converting from the natural log value back to the
original actual count values to see what the population numbers look like. Note
the use of `exp() - 1` in the `y` aesthetic, to transform the values from the
`ln() + 1` values. Doing this shows us the original data's values and helps
demonstrate why the data were log transformed for analysis. To examine the data,
first we will use boxplots and then quantile-quantile (qq) plots.


```r
ggplot(nema_long,
       aes(x = Temperature, 
           y = exp(Log_pop) - 1,
           group = Temperature,
           colour = Temperature)) +
  geom_boxplot(colour = "grey",
               outlier.color = NA) +
  geom_jitter(width = 0.1,
              alpha = 0.6) +
  ylab(expression(paste("exp(ln(",
                        italic("P. thornei"),
                        "/kg soil) + 1)"),
                  sep = "")) +
  facet_wrap( ~ Variety,
              ncol = 2) +
  scale_colour_viridis("Temperature") +
  ggtitle("Untransformed Data") +
  theme_minimal()
```

![](/Users/adamsparks/Sources/GitHub/Adam/adamhsparks/content/blog/Fitting_Nematode_Models_files/figure-html/boxplots_original-1.png)<!-- -->


```r
ggplot(nema_long,
       aes(sample = exp(Log_pop) - 1)) +
  stat_qq() +
  facet_wrap(~ Variety,
             ncol = 2) +
  theme_minimal()
```

![](/Users/adamsparks/Sources/GitHub/Adam/adamhsparks/content/blog/Fitting_Nematode_Models_files/figure-html/qq_original-1.png)<!-- -->

The boxplots show that there is a wide range of values with the 25 ˚C
temperature populations close to zero with others having quite large ranges,
this could indicate heteroscedasticity.

Also, looking at the qq-plots it is apparent that the original data do not meet
the assumptions of normally distributed errors for a linear model. See the
[Further Reading] section for suggested reading on interpreting qq-plots.


```r
ggplot(nema_long,
       aes(x = Temperature, 
           y = Log_pop,
           group = Temperature,
           colour = Temperature)) +
  geom_boxplot(colour = "grey",
               outlier.color = NA) +
  geom_jitter(width = 0.1,
              alpha = 0.6) +
  ylab(expression(paste("exp(ln(",
                        italic("P. thornei"),
                        "/kg soil) + 1)"),
                  sep = "")) +
  facet_wrap( ~ Variety,
              ncol = 2) +
  scale_colour_viridis("Temperature") +
  ggtitle("Log Transformed Data") +
  theme_minimal()
```

![](/Users/adamsparks/Sources/GitHub/Adam/adamhsparks/content/blog/Fitting_Nematode_Models_files/figure-html/boxplots_ln-1.png)<!-- -->


```r
ggplot(nema_long,
       aes(sample = Log_pop)) +
  stat_qq() +
  facet_wrap(~ Variety,
             ncol = 2) +
  theme_minimal()
```

![](/Users/adamsparks/Sources/GitHub/Adam/adamhsparks/content/blog/Fitting_Nematode_Models_files/figure-html/qq_ln-1.png)<!-- -->

Here we see that the `log()` transformed data's boxplots show fewer outliers and
tighter range of values. The qq-plots also indicate that it is possible to
conduct a linear regression with these data.

## Using AIC to Compare Model Quality

Even though the original paper used a linear model for the unplanted data, a
polynomial model also fits these data quite well. We can compare the original
linear model from the paper with a polynomial model quite easily in R to see how
the models compare using AIC (Akaike information criterion). AIC is used to
measure the models' relative quality to each other.

Since the `unplanted_model` object already exists as a product of the linear
model, we simply need to use the polynomial model with the unplanted data to
create a new object to compare them.


```r
unplanted_poly_model <- nema_long %>%
  filter(Variety == "Unplanted") %>% 
  quadratic_model()

par(mfrow = c(2, 2))
plot(unplanted_poly_model)
```

![](/Users/adamsparks/Sources/GitHub/Adam/adamhsparks/content/blog/Fitting_Nematode_Models_files/figure-html/unplanted_poly-1.png)<!-- -->

```r
summary(unplanted_poly_model)
```

```
## 
## Call:
## lm(formula = Log_pop ~ Degree_days + I(Degree_days^2), data = df)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -0.4870 -0.2387 -0.0804  0.1921  0.9747 
## 
## Coefficients:
##                      Estimate   Std. Error t value       Pr(>|t|)    
## (Intercept)       5.061614851  0.403124966    12.6 0.000000000031 ***
## Degree_days       0.002125214  0.000851143     2.5          0.021 *  
## I(Degree_days^2) -0.000000401  0.000000402    -1.0          0.329    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.385 on 21 degrees of freedom
## Multiple R-squared:  0.71,	Adjusted R-squared:  0.683 
## F-statistic: 25.7 on 2 and 21 DF,  p-value: 0.00000226
```

By this information, the $R^2$ value is a bit better from the
`unplanted_poly_model`, 0.7101, than 
the original `unplanted_model`'s, 0.6964.
Using the same code from above it is easy to visualise the new model's fit using
**`ggplot2`**.


```r
nema_long %>%
  group_by(Variety) %>%
  filter(Variety == "Unplanted") %>%
  ggplot(aes(
    x = Degree_days,
    y = Log_pop,
    colour = Temperature,
  )) +
  geom_point() +
  geom_smooth(method = "lm",
              formula = y ~ x + I(x^2),
              size = 1,
              se = FALSE,
              colour = "grey",
              alpha = 0.5) +
  ylab(expression(paste("ln(",
                        italic("P. thornei"),
                        "/kg soil) + 1"),
                  sep = "")) +
  xlab("Thermal Time (˚C Days Above 10˚C)") +
  theme_minimal() +
  scale_colour_viridis("Temperature") +
  ggtitle("Unplanted Quadratic Model")
```

![](/Users/adamsparks/Sources/GitHub/Adam/adamhsparks/content/blog/Fitting_Nematode_Models_files/figure-html/visualise_unplanted_poly_model-1.png)<!-- -->

Checking the model fit visually, we can see that it fits the data nicely. To get
a better feel for how these models compare, AIC can be used to determine the
relative quality of a model for a _given set of data_. That is, you cannot
compare models for other data using AIC.

Checking the AIC is quite simple in R, just `AIC()`. Here we check the AIC of
the original linear `unplanted_model` and the new `unplanted_poly_model`.


```r
AIC(unplanted_model)
```

```
## [1] 26.17
```

```r
AIC(unplanted_poly_model)
```

```
## [1] 27.06
```

Ideally when fitting models, you look for the least complex model that provides
the best explanation of the variation in the data. In this case the original
linear model has a lower AIC, 26.1715, than that of the
polynomial model, 27.058, but they are extremely close
and the $R^2$ value of the polynomial model, 
0.7101, is a bit better than the linear
model's $R^2$, 0.6964, as well.
Therefore, without more data to distinguish the models it appears that either
model suffices for the data provided.

# Further Reading

## Tidy Data

Wickham [-@TIDY-DATA2014] introduced the idea of tidy data for analysis. As you
work with raw data from many sources, it is useful to understand what this means
and why it is useful. In this example, **`tidyr`** was used to convert the data
from wide to long format. For a more in-depth look at using **`tidyr`** see:

- [Introducing tidyr](https://blog.rstudio.com/2014/07/22/introducing-tidyr/)

- [Gather columns into key-value pairs](http://tidyr.tidyverse.org/reference/gather.html).

## Interpreting Linear Models in R

The University of Georgia has a nice, easy to understand set of materials that
demonstrate how to interpret diagnostic plot outputs from `plot(lm.object)`,
[Regression diagnostic plots](http://strata.uga.edu/8370/rtips/regressionPlots.html)
on their Data Analysis in the Geosciences page. For even more, this
Cross Validated question has an excellent discussion on
[Interpreting plot.lm()](https://stats.stackexchange.com/questions/58141/interpreting-plot-lm).

The University of Montana provides an on-line text, "_Statistics With R_", that
includes a section on [ANOVA model diagnostics including QQ-plots](https://arc.lib.montana.edu/book/statistics-with-r-textbook/item/57).
Since ANOVA uses `lm()` in R, the tools and descriptions here are applicable to
the qq-plots we have generated here in this illustration.

For a detailed look at how to interpret the output from `summary()` for linear
models, see The YHAT Blog post,
[Fitting & Interpreting Linear Models in R](http://blog.yhat.com/posts/r-lm-summary.html).

Faraway [-@FARAWAY2002],
"[_Practical Regression and Anova using R_](https://cran.r-project.org/doc/contrib/Faraway-PRA.pdf)"
is an excellent free resource that goes into detail about fitting linear models
using R and how to interpret the diagnostics. Prof. Faraway has more recent
books on the subject as well that you might wish to borrow from your library or
purchase, see
[http://www.maths.bath.ac.uk/~jjf23/LMR/](http://www.maths.bath.ac.uk/~jjf23/LMR/)
for more details.

## Selecting the Right Colour Scheme

Selecting good colour schemes is essential for communicating your message.
The **`viridis`** package makes this much easier to do. Bob Rudis has a nice
blog post when the package was first introduced that demonstrates why it is
useful to use a package like this for your colour palettes,
[Using the new ‘viridis’ colormap in R (thanks to Simon Garnier)](https://rud.is/b/2015/07/20/using-the-new-viridis-colormap-in-r-thanks-to-simon-garnier/). Other colour palettes for R exist as well. Notably the
**`RColorBrewer`** package provides an easy-to-use interface for the fantastic
Colour Brewer palettes [http://colorbrewer2.org/](http://colorbrewer2.org/)
commonly used for cartography but also useful for graphs.

# Reproducibility


```
## ─ Session info ───────────────────────────────────────────────────────────────
##  setting  value                       
##  version  R version 4.0.3 (2020-10-10)
##  os       macOS Catalina 10.15.7      
##  system   x86_64, darwin17.0          
##  ui       X11                         
##  language (EN)                        
##  collate  en_AU.UTF-8                 
##  ctype    en_AU.UTF-8                 
##  tz       Australia/Brisbane          
##  date     2020-11-27                  
## 
## ─ Packages ───────────────────────────────────────────────────────────────────
##  package     * version    date       lib source                              
##  assertthat    0.2.1      2019-03-21 [1] CRAN (R 4.0.3)                      
##  backports     1.2.0      2020-11-02 [1] CRAN (R 4.0.3)                      
##  broom         0.7.2      2020-10-20 [1] CRAN (R 4.0.2)                      
##  callr         3.5.1      2020-10-13 [1] CRAN (R 4.0.2)                      
##  cellranger    1.1.0      2016-07-27 [1] CRAN (R 4.0.3)                      
##  cli           2.2.0      2020-11-20 [1] CRAN (R 4.0.3)                      
##  colorspace    2.0-0      2020-11-11 [1] CRAN (R 4.0.3)                      
##  crayon        1.3.4.9000 2020-11-15 [1] Github (r-lib/crayon@4bceba8)       
##  DBI           1.1.0      2019-12-15 [1] CRAN (R 4.0.3)                      
##  dbplyr        2.0.0      2020-11-03 [1] CRAN (R 4.0.3)                      
##  desc          1.2.0      2018-05-01 [1] CRAN (R 4.0.3)                      
##  devtools      2.3.1.9000 2020-11-15 [1] Github (r-lib/devtools@b3be019)     
##  digest        0.6.27     2020-10-24 [1] CRAN (R 4.0.2)                      
##  dplyr       * 1.0.2      2020-08-18 [1] CRAN (R 4.0.2)                      
##  ellipsis      0.3.1      2020-05-15 [1] CRAN (R 4.0.2)                      
##  evaluate      0.14       2019-05-28 [1] CRAN (R 4.0.3)                      
##  fansi         0.4.1      2020-01-08 [1] CRAN (R 4.0.3)                      
##  farver        2.0.3      2020-01-16 [1] CRAN (R 4.0.3)                      
##  forcats     * 0.5.0      2020-03-01 [1] CRAN (R 4.0.3)                      
##  fs            1.5.0      2020-07-31 [1] CRAN (R 4.0.2)                      
##  generics      0.1.0      2020-10-31 [1] CRAN (R 4.0.2)                      
##  ggplot2     * 3.3.2      2020-06-19 [1] CRAN (R 4.0.2)                      
##  glue          1.4.2      2020-08-27 [1] CRAN (R 4.0.2)                      
##  gridExtra     2.3        2017-09-09 [1] CRAN (R 4.0.3)                      
##  gtable        0.3.0      2019-03-25 [1] CRAN (R 4.0.3)                      
##  haven         2.3.1      2020-06-01 [1] CRAN (R 4.0.2)                      
##  hms           0.5.3      2020-01-08 [1] CRAN (R 4.0.3)                      
##  htmltools     0.5.0      2020-06-16 [1] CRAN (R 4.0.2)                      
##  httr          1.4.2.9000 2020-11-03 [1] Github (hadley/httr@cb4e20c)        
##  jsonlite      1.7.1      2020-09-07 [1] CRAN (R 4.0.2)                      
##  kableExtra  * 1.3.1      2020-10-22 [1] CRAN (R 4.0.2)                      
##  knitr         1.30       2020-09-22 [1] CRAN (R 4.0.2)                      
##  labeling      0.4.2      2020-10-20 [1] CRAN (R 4.0.2)                      
##  lattice       0.20-41    2020-04-02 [1] CRAN (R 4.0.2)                      
##  lifecycle     0.2.0      2020-03-06 [1] CRAN (R 4.0.3)                      
##  lubridate     1.7.9.9001 2020-11-25 [1] Github (tidyverse/lubridate@6c535c8)
##  magrittr      2.0.1      2020-11-17 [1] CRAN (R 4.0.3)                      
##  Matrix        1.2-18     2019-11-27 [2] CRAN (R 4.0.3)                      
##  memoise       1.1.0      2017-04-21 [1] CRAN (R 4.0.3)                      
##  mgcv          1.8-33     2020-08-27 [1] CRAN (R 4.0.2)                      
##  modelr        0.1.8      2020-05-19 [1] CRAN (R 4.0.2)                      
##  munsell       0.5.0      2018-06-12 [1] CRAN (R 4.0.3)                      
##  nlme          3.1-150    2020-10-24 [1] CRAN (R 4.0.2)                      
##  pillar        1.4.7      2020-11-20 [1] CRAN (R 4.0.3)                      
##  pkgbuild      1.1.0      2020-07-13 [1] CRAN (R 4.0.2)                      
##  pkgconfig     2.0.3      2019-09-22 [1] CRAN (R 4.0.3)                      
##  pkgload       1.1.0      2020-05-29 [1] CRAN (R 4.0.2)                      
##  prettyunits   1.1.1      2020-01-24 [1] CRAN (R 4.0.3)                      
##  processx      3.4.4      2020-09-03 [1] CRAN (R 4.0.2)                      
##  ps            1.4.0      2020-10-07 [1] CRAN (R 4.0.2)                      
##  purrr       * 0.3.4      2020-04-17 [1] CRAN (R 4.0.2)                      
##  R6            2.5.0      2020-10-28 [1] CRAN (R 4.0.2)                      
##  Rcpp          1.0.5      2020-07-06 [1] CRAN (R 4.0.2)                      
##  readr       * 1.4.0      2020-10-05 [1] CRAN (R 4.0.2)                      
##  readxl        1.3.1      2019-03-13 [1] CRAN (R 4.0.3)                      
##  remotes       2.2.0      2020-07-21 [1] CRAN (R 4.0.2)                      
##  reprex        0.3.0      2019-05-16 [1] CRAN (R 4.0.2)                      
##  rlang         0.4.9      2020-11-26 [1] CRAN (R 4.0.3)                      
##  rmarkdown     2.5        2020-10-21 [1] CRAN (R 4.0.3)                      
##  rprojroot     2.0.2      2020-11-15 [1] CRAN (R 4.0.3)                      
##  rstudioapi    0.13       2020-11-12 [1] CRAN (R 4.0.3)                      
##  rvest         0.3.6      2020-07-25 [1] CRAN (R 4.0.2)                      
##  scales        1.1.1      2020-05-11 [1] CRAN (R 4.0.2)                      
##  sessioninfo   1.1.1      2018-11-05 [1] CRAN (R 4.0.2)                      
##  stringi       1.5.3      2020-09-09 [1] CRAN (R 4.0.2)                      
##  stringr     * 1.4.0      2019-02-10 [1] CRAN (R 4.0.3)                      
##  testthat      3.0.0.9000 2020-11-26 [1] Github (r-lib/testthat@efaf620)     
##  tibble      * 3.0.4      2020-10-12 [1] CRAN (R 4.0.2)                      
##  tidyr       * 1.1.2      2020-08-27 [1] CRAN (R 4.0.2)                      
##  tidyselect    1.1.0      2020-05-11 [1] CRAN (R 4.0.2)                      
##  tidyverse   * 1.3.0      2019-11-21 [1] CRAN (R 4.0.3)                      
##  usethis       1.9.0.9000 2020-11-26 [1] Github (r-lib/usethis@6dd738e)      
##  vctrs         0.3.5      2020-11-17 [1] CRAN (R 4.0.3)                      
##  viridis     * 0.5.1      2018-03-29 [1] CRAN (R 4.0.3)                      
##  viridisLite * 0.3.0      2018-02-01 [1] CRAN (R 4.0.3)                      
##  webshot       0.5.2      2019-11-22 [1] CRAN (R 4.0.3)                      
##  withr         2.3.0      2020-09-22 [1] CRAN (R 4.0.2)                      
##  xfun          0.19       2020-10-30 [1] CRAN (R 4.0.2)                      
##  xml2          1.3.2      2020-04-23 [1] CRAN (R 4.0.2)                      
##  yaml          2.2.1      2020-02-01 [1] CRAN (R 4.0.3)                      
## 
## [1] /Users/adamsparks/Library/R/4.0/library
## [2] /Library/Frameworks/R.framework/Versions/4.0/Resources/library
```

# References

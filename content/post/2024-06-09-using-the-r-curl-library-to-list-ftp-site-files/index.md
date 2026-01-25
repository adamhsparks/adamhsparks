---
title: Using the R {curl} Library to List FTP Site Files
author: Adam Sparks
date: '2024-06-09'
slug: using-the-r-curl-library-to-list-ftp-site-files
categories: []
tags: [R]
comments: no
images: ~
---

Converting a relatively obscure GitHub Gist to a proper blog post.

There are still some sites that use FTP, not a more modern API or even just http(s).
I'm [looking at you BOM](http://www.bom.gov.au/catalogue/anon-ftp.shtml).
Sometimes it's useful to know what files are available on the server in you R session.

Using this code snippet you can easily get a list of files on the FTP server in your R session.


``` r
library(curl)
```

```
## Using libcurl 8.14.1 with LibreSSL/3.3.6
```

``` r
ftp_base <- "ftp://ftp.bom.gov.au/anon/gen/"
list_files <- curl::new_handle()
curl::handle_setopt(list_files, ftp_use_epsv = TRUE, dirlistonly = TRUE)

con <- curl::curl(url = ftp_base, "r", handle = list_files)
files <- readLines(con)
close(con)

files
```

```
##  [1] "Notification_of_file_removal.txt" "README"                          
##  [3] "charts_data"                      "clim_data"                       
##  [5] "difacs"                           "fwo"                             
##  [7] "gms"                              "nmgu"                            
##  [9] "nwp"                              "radar"                           
## [11] "radar_transparencies"             "vaac"
```

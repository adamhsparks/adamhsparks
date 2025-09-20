---
title: Estimation of AUDPC From Two Points
author: Adam Sparks
date: '2025-01-22'
slug: estimation-of-audpc-from-two-points
categories: [R]
tags: [R, Phytopathology]
comments: no
images: ~
bibliography: references.bib
---

Today we had a data set come in that the researcher requested AUDPC (Area Under the Disease Progress Curve) [@Shaner1977] be calculated from two points.
This is a common request as it's quite time and labour intensive to collect these data, especially in breeding trials and can be done with a simple formula from @Jeger2001.
However, I wasn't aware of any R package that implemented this calculation, so I wrote a function to do it.

Note that your values for disease severity must be between 0 and 1, so if you are using a percentage scale, you will need to divide by 100.


``` r
audpc_2_points <- function(time, y0, yT) {

  stopifnot("`y0` and `yT` must be between 0 and 1 inclusive" =
            (y0 >= 0L & y0 <= 1L) && (yT >= 0L & yT <= 1L))

  # eqn. 3 from Jeger and Viljanen-Rollinson (2001), rate parameter r
  r <- (log(yT / (1L - yT)) - log(y0 / (1L - y0))) / time
 
  # eqn. 2 from Jeger and Viljanen-Rollinson (2001), AUDPC estimation
  return(time + log(y0 / yT) / r)
}
```

Using the [example as seen in the documentation for AUDPC](https://alvesks.github.io/epifitter/reference/AUDPC.html) from @dosS.Alves2021 we can calculate AUDPC using the trapezoidal method.


``` r
library(epifitter)

epi <- sim_logistic(N = 30, y0 = 0.01,dt = 5, r = 0.3, alpha = 0.5, n = 1)

(eg_1 <- AUDPC(time = epi$time, y = epi$y, y_proportion = TRUE))
```

```
## [1] 14.69147
```

Using the same data, we can calculate AUDPC from two points.


``` r
# time using the last time-step point
epi$time[7]
```

```
## [1] 30
```

``` r
# y0 using the first disease incidence point
epi$y[1]
```

```
## [1] 0.01
```

``` r
# yT using the last disease incidence point
epi$y[7]
```

```
## [1] 0.9879302
```

``` r
(eg_2 <- audpc_2_points(time = epi$time[7], y0 = epi$y[1], yT = epi$y[7]))
```

```
## [1] 14.68996
```

We can see that the values are very similar, but not identical, *i.e.*, our two point method results in 14.6899594, while the traditional method provides, 14.6914735, which is what @Jeger2001 proposes we should expect, values that are close enough to be useful but not identical.

# References

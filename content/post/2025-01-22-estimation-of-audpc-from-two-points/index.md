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

Today we had a data set come in that the researcher requested AUDPC (Area Under the Disease Progress Curve) (Shaner and Finney 1977) be calculated from two points.
This is a common request as it’s quite time and labour intensive to collect these data, especially in breeding trials and can be done with a simple formula from Jeger and Viljanen-Rollinson (2001).
However, I wasn’t aware of any R package that implemented this calculation, so I wrote a function to do it.

``` r
audpc_2_points <- function(time, y0, yT) {
  # eqn. 3 from Jeger and Viljanen-Rollinson (2001), rate parameter r
  r <- (log(yT / (1 - yT)) - log(y0 / (1 - y0))) / time
  
  # eqn. 2 from Jeger and Viljanen-Rollinson (2001), AUDPC estimation
  return(time + log(y0 / yT) / r)
}
```

Using the [example as seen in the documentation for AUDPC](https://alvesks.github.io/epifitter/reference/AUDPC.html) from dos S. Alves and Del Ponte (2021) we can calculate AUDPC using the trapezoidal method.

``` r
library(epifitter)

epi <- sim_logistic(N = 30, y0 = 0.01,dt = 5, r = 0.3, alpha = 0.5, n = 1)

(eg_1 <- AUDPC(time = epi$time, y = epi$y, y_proportion = TRUE))
```

    ## [1] 14.69147

Using the same data, we can calculate AUDPC from two points.

``` r
# time using the last time-step point
epi$time[7]
```

    ## [1] 30

``` r
# y0 using the first disease incidence point
epi$y[1]
```

    ## [1] 0.01

``` r
# yT using the last disease incidence point
epi$y[7]
```

    ## [1] 0.9879302

``` r
(eg_2 <- audpc_2_points(time = epi$time[7], y0 = epi$y[1], yT = epi$y[7]))
```

    ## [1] 14.68996

We can see that the values are very similar, but not identical, *i.e.*, our two point method results in 14.6899594, while the traditional method provides, 14.6914735, which is what Jeger and Viljanen-Rollinson (2001) proposes we should expect, values that are close enough to be useful but not identical.

# References

<div id="refs" class="references csl-bib-body hanging-indent" entry-spacing="0">

<div id="ref-dosS.Alves2021" class="csl-entry">

dos S. Alves, Kaique, and Emerson M. Del Ponte. 2021. *<span class="nocase">epifitter</span>: Analysis and Simulation of Plant Disease Progress Curves*. <https://CRAN.R-project.org/package=epifitter>.

</div>

<div id="ref-Jeger2001" class="csl-entry">

Jeger, M. J., and S. L. H. Viljanen-Rollinson. 2001. “The Use of the Area Under the Disease-Progress Curve (AUDPC) to Assess Quantitative Disease Resistance in Crop Cultivars.” *Theoretical and Applied Genetics* 102: 32–40.

</div>

<div id="ref-Shaner1977" class="csl-entry">

Shaner, Gregory, and Robert E. Finney. 1977. “The Effect of Nitrogen Fertilization on the Expression of Slow-Mildewing Resistance in Knox Wheat.” *Phytopathology* 67 (8): 1051–56.

</div>

</div>

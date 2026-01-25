---
title: Look Ma, no codecov.io!
author: Adam Sparks
date: '2026-01-24'
slug: look-ma-no-codecov-io
categories: [R, software-development, testing, continuous-integration]
tags: [R]
comments: false
images: ~
---

Recently I had asked the Fediverse how I could get codecov.io to work with Codeberg Actions.
Ultimately, it's not possible to do so directly.
But, I then [realised that I didn't need codecov.io](https://rstats.me/@adamhsparks/115914052386020580) at all.
Codecov.io is a third-party service that hosts code coverage reports, but with a local R session, I can generate and view these reports directly within my repository.

I set up my README to include a badge that shows the code coverage percentage using the `covr` package.

First, in the setup chunk of my R Markdown file, I load the `covr` package and calculate the coverage percentage, rounding it to the nearest whole number:


``` r
library(covr)
coverage <- percent_coverage(package_coverage())
coverage <- round(coverage, 0)
```

Then I generate a badge URL using [shields.io](https://shields.io/) that reflects the coverage percentage:


``` r
[![Code Coverage: `r coverage`%](https://img.shields.io/badge/code_coverage-`r coverage`%25-green)](#code-coverage)
```

Towards the end of my file, I have this:


````
## 
##  ## Code Coverage
##  
##  ```{r codecov, echo=FALSE}
##  covr::package_coverage()
##  ```
````

Which generates a detailed code coverage report directly in the rendered document.
This doesn't include the clickable details that are possible with cocodecov.io, but it provides all the necessary information right there in the repository.

Here's what the rendered README looks like with the badge and report: <https://codeberg.org/adamhsparks/epicrop/src/branch/main/README.md>.

Alternatively, [pacha](https://github.com/pachadotdev), has come up with a method for using GitHub actions and automated it even further.
See his YAML workflow file here: <https://github.com/pachadotdev/armadillo4r/blob/main/.github/workflows/test-coverage.yaml>.

This is something I could probably adapt to my local workflow that would change the badge colour as pacha has done.
The other thing I could do, is to just use Codeberg to run a similar workflow and generate/update the badge in the README as he has done with GitHub.

As someone else on Mastodon opined, there's no shame in getting away from a third party solution if you can manage it yourself.
Especially given the ongoing [enshitfication](https://pluralistic.net/2023/08/27/an-audacious-plan-to-halt-the-internets-enshittification-and-throw-it-into-reverse/) of many of the resources that we've taken for granted for FOSS over the years.

I think back to using Circle-CI or Travis for running CI before GitHub started offering it and recall when Travis started charging to use it and wonder, how long before we are charged for codecov.io as well?

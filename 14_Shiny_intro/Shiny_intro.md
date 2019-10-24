Introduction to Shiny
========================================================
author: Clark Richards and Chantelle Layton
date: 2019-11-01
autosize: true


What is Shiny?
========================================================
incremental: true

> Shiny is an open source R package that provides an elegant and powerful web framework for building web applications using R. Shiny helps you turn your analyses into interactive web applications without requiring HTML, CSS, or JavaScript knowledge

<https://shiny.rstudio.com>



2 essential elements:
- a user interface, i.e. `ui`
- a `server`, which contains the code for the app

Slide With Code
========================================================


```r
summary(cars)
```

```
     speed           dist       
 Min.   : 4.0   Min.   :  2.00  
 1st Qu.:12.0   1st Qu.: 26.00  
 Median :15.0   Median : 36.00  
 Mean   :15.4   Mean   : 42.98  
 3rd Qu.:19.0   3rd Qu.: 56.00  
 Max.   :25.0   Max.   :120.00  
```

Slide With Plot
========================================================

![plot of chunk unnamed-chunk-2](Shiny_intro-figure/unnamed-chunk-2-1.png)

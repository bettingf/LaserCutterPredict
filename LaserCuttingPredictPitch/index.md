---
title       : LaserCutterPredict
subtitle    : A new way to estimate laser cutter parameters.
author      : Franck Bettinger
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides

---

## The problem

1. Laser cutter parameters are hard to estimate
2. Tests are needed 
  * waste of time
  * waste of material
  * potential fire (safety issue)
3. When using differents materials
  * parameters are hard to remember
  * making a list could be long
4. When using differents thicknesses
  * different power
  * different speed

---

## The solution

1. Create a database of parameters
  * for different materials
  * for different thicknesses
  
2. Estimate parameters for a material
  * find the closest match (with power median speed)
  * find power for different speeds (saving time)
  * give only power values the machine can deliver
  
3. Estimate parameters for thicknesses
  * when the material has been used before
  * when that thickness is not in the database
  * by linear regression

---

## The software

1. Multilangual (English / French)

2. Add/download known laser cutter parameters

3. Predictions and a graph to check linear assumption

<img src="assets/fig/unnamed-chunk-1-1.png" title="plot of chunk unnamed-chunk-1" alt="plot of chunk unnamed-chunk-1" style="display: block; margin: auto;" />

---

## Example of prediction by thickness


```
## Error in print(xtable(data2), type = "html"): could not find function "xtable"
```





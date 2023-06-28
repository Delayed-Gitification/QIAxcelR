# QIAxcelR
Tools for analysing QIAxcel in R

## Instructions

### Set up

Install python and pybaseline and scipy

In R, run this before any of the other functions:

```
library(QIAxcelR)
library(tidyverse)
library(reticulate)
use_python("/path/to/python.exe")
py <- import("pybaselines")
scipy <- import("scipy")
```

### Parse the data

The output from the QIAxcel is weird. Use this function to get it into a "tidy" format

```
df <- parse_qiaxcel_output(filename)
```

### Preprocess the data

Next, we need to calculate a baseline and subtract it. We also need to find the lower and upper markers.

Run

```
df2 <- preprocess_dataframe(df)
```

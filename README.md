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

### Plot the data

We can use geom_tile() from ggplot to plot the data in a way that looks like the normal QIAxcel output

```
ggplot(df2, 
       aes(y = index_for_plotting, fill = corrected_value, x = unique_id)) +
  geom_tile() +
  theme_classic() +
  scale_fill_gradient(low = "white", high = "black") +
  ylim(0,1)
```

### Tweaking positions of upper and lower markers

To tweak the positions of a given sample, make a dataframe with three columns:
1. unique_id - this should match the ids in the processed df eg "D8" or "A11"
2. multiply - how much to multiply each position
3. shift - how much to shift (i.e. translate) each position

You only need to add samples that need to be tweaked

Then run (assuming your new dataframe is called tweak_df)

```
processed_df <- tweak_positions(processed, tweak_df)
```

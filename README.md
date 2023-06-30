# QIAxcelR
Tools for analysing QIAxcel in R

## Instructions

### Set up

Install python and pybaseline and scipy

If you need to build a new version of the package, change the working directory to the QIAxcelR directory and run

```
library(devtools)
build()
```

To install the package, run:
```
install.packages("/your/path/QIAxcelR_0.1.0.tar.gz", repos = NULL, type = "source")
```
(obviously if the name or version is different then change this)

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

The "corrected_index" scales the position between 0 and 1 between the lower and upper markers. 
The "corrected_value" is the baseline-corrected signal.
The "index_for_plotting" is a rounded version of the corrected index that should be used for plotting with ggplot.

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
processed_df <- tweak_positions(processed_df, tweak_df)
```

Plot the tweaked dataframe to make sure that it's aligned correctly.

### Integrating peaks

Now that you have your samples aligned nicely, you can integrate peaks.

Obviously we don't have the benefit of a mouse and GUI here. However, assuming the alignment is good, we can simply integrate the values between a given range (which, because it is background subtracted, should give us the total intensity of a given band)

For example:
```
ratios <- processed_df %>%
  mutate(band = case_when(abs(corrected_index - 0.58) < 0.02 ~ "lower_band",
                          abs(corrected_index - 0.715) < 0.035 ~ "upper_band",
                          T ~ "ignore")) %>%
  group_by(unique_id, band) %>%
  mutate(integrated_area = sum(corrected_value)) %>%
  distinct(unique_id, band, integrated_area) %>%
  filter(band != "ignore") %>%
  pivot_wider(names_from = band, values_from = integrated_area) %>%
  mutate(fraction_lower_band = lower_band/(lower_band+upper_band))
```

We can also calculate a molar ratio rather than just an intensity ratio.

For example:
```
molar_ratios <- processed_df %>%
  mutate(band = case_when(abs(corrected_index - 0.58) < 0.02 ~ "lower_band",
                          abs(corrected_index - 0.715) < 0.035 ~ "upper_band",
                          T ~ "ignore")) %>%
  mutate(product_length = case_when(band == "upper_band" ~ 500,
                                    band == "lower_band" ~ 300,
                                    T ~ 0)) %>%
  group_by(unique_id, band) %>%
  mutate(integrated_area = sum(corrected_value)) %>%
  distinct(unique_id, band, integrated_area, product_length) %>%
  mutate(molar_value = integrated_area / product_length) %>%
  filter(band != "ignore") %>%
  ungroup() %>%
  dplyr::select(-product_length, -integrated_area) %>%
  pivot_wider(names_from = band, values_from = molar_value) %>%
  mutate(molar_fraction_lower_band = lower_band/(lower_band+upper_band))
```

Alternatively just use the wrapper function for this:
```
molar_ratios <- find_molar_ratios(processed_df, lower_band_pos = 0.58, lower_band_width = 0.02, lower_band_nts = 300,
                        upper_band_pos= 0.715, upper_band_width = 0.035, upper_band_nts = 500)
```

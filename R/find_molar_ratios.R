find_molar_ratios <- function(df, lower_band_pos, lower_band_nts, lower_band_width,
                              upper_band_pos, upper_band_nts, upper_band_width){
  df <- df %>%
    mutate(band = case_when(abs(corrected_index - lower_band_pos) < lower_band_width ~ "lower_band",
                            abs(corrected_index - upper_band_pos) < upper_band_width ~ "upper_band",
                            T ~ "ignore")) %>%
    mutate(product_length = case_when(band == "upper_band" ~ upper_band_nts,
                                      band == "lower_band" ~ lower_band_nts,
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
  
  return(df)
}
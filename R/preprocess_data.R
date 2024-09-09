preprocess_data <- function(values, prominence=0.2){
  
  values2 <- as.numeric(correct_baseline(values))
  
  peaks <- find_peaks(values2, prominence = prominence)
  
  lower_marker = find_local_max(values, min(peaks))
  upper_marker = find_local_max(values, max(peaks))
  marker_dist = upper_marker - lower_marker
  stopifnot(marker_dist > 0)
  
  final_df <- data.frame(corrected_value = values2) %>%
    mutate(index = 1:n()) %>%
    mutate(corrected_index = (index-lower_marker)/marker_dist)
  
  return(final_df)
}

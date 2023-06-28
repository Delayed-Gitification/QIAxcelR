find_local_max <- function(values, peak, width = 8){
  # Sometimes the scipy peak isn't the local max for some reason...
  # This function looks for the actual local max near the called peak
  
  df <- data.frame(value = values) %>%
    mutate(index = 1:n()) %>%
    filter(abs(index-peak) <= width) %>%
    slice_max(value)
  
  return(df$index[1])
}

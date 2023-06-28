tweak_positions <- function(processed_df, tweak_df){
  processed_df <- processed_df %>%
    left_join(tweak_df, by = "unique_id")
  
  processed_df$multiply[is.na(processed_df$multiply)] <- 1
  processed_df$shift[is.na(processed_df$shift)] <- 0
  
  
  processed_df <- processed_df %>%
    mutate(corrected_index = corrected_index*multiply + shift) %>%
    mutate(index_for_plotting = round(corrected_index, 3))
  
  return(processed_df)
}
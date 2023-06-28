preprocess_dataframe <- function(df, prominence=0.2){
  processed_list <- df %>%
    filter(!is.na(value2)) %>%
    mutate(unique_id = paste0(Row, sample)) %>%
    split(.$unique_id) %>%
    map(~preprocess_data(.$value2))
  
  final_output <- bind_rows(processed_list, .id = "unique_id") %>%
    ungroup() %>%
    mutate(column = as.numeric(str_sub(unique_id, 2, -1)),
           row = str_sub(unique_id, 1, 1),
           index_for_plotting = round(corrected_index, 3))
  
  return(final_output)
}
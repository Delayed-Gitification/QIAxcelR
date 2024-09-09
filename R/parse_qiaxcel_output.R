parse_qiaxcel_output <- function(filename){
  library(tidyverse)
  
  df <- read_tsv(filename) %>%
    pivot_longer(cols = contains("RFU")) %>%
    mutate(sample = as.numeric(str_sub(name,6, 7)))  %>%
    select(Time, Row, sample, value) %>% 
    dplyr::rename(value2 = value, time2 = Time) %>%
    filter(!is.na(value2)) %>%
    mutate(value2 = as.numeric(value2))
  
  return(df)
}
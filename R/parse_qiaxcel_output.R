parse_qiaxcel_output <- function(filename){
  library(tidyverse)
  
  df <- read_tsv(filename) %>%
    pivot_longer(cols = contains("RFU")) %>%
    mutate(sample = as.numeric(str_sub(name,6, 7)))  %>%
    select(Time, Row, sample, value) %>% 
    dplyr::rename(value2 = value, time2 = Time) 
  
  return(df)
}
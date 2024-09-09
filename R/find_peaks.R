find_peaks <- function(values, prominence=0.3){
  # This function uses scipy to find and integrate peaks
  
  peaks <- as.integer(scipy$signal$find_peaks(values, prominence = prominence)[[1]])
  
  return(peaks)
}

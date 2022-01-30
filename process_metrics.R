library(jsonlite)

process_app_results <- function(dir) {
  files <- list.files(dir, pattern="*.json")
  
  results <- list()
  
  for (f in files) {
    fres <- list()
    info = strsplit(f, "_")

    fres[["dataset"]] <- info[[1]][1]
    fres[["run"]] <- info[[1]][2]
    
    metrics =  jsonlite::fromJSON(file.path(dir, f))
    fres[["time"]] <- metrics[["CustomTotalAnalysisTime"]]
    fres[["jsTotalHeapSize"]] <- metrics[["JSHeapTotalSize"]]
    fres[["JSHeapUsedSize"]] <- metrics[["JSHeapUsedSize"]]
    
    results[[f]] <- fres
  }
  
  as.data.frame(do.call(rbind, lapply(results, as.vector)))
}


process_cli_results <- function(dir) {
  dirs <- dir(dir)
  
  results <- list()
  
  for (d in dirs) {
    runs <- list.files(file.path(dir, d))
    
    for (r in runs) {
      
      fres <- list()
      
      fres[["dataset"]] <- d
      fres[["run"]] <- r
      
      metrics <- readLines(file.path(dir, d, r))
      
      usertime <- metrics[19]
      memory <- metrics[27]
      
      fres[["time"]] <- strsplit(usertime, ":")[[1]][2]
      
      fres[["maxResidentSetSize"]] <- strsplit(memory, ":")[[1]][2]
      
      results[[file.path(dir, d, r)]] <- fres
      
    } 
  }
  
  as.data.frame(do.call(rbind, lapply(results, as.vector)))
  
}

df_app <- process_app_results("./app-results")
df_cli <- process_cli_results("./cli-results")
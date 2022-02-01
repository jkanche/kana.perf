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
    fres[["time"]] <- metrics[["CustomTotalAnalysisTime"]] / 1000
    fres["WasmMemory"] <- metrics[["CustomWasmMemUsage"]] / (1024 ^ 2)
    fres[["jsTotalHeapSize"]] <- metrics[["JSHeapTotalSize"]] / (1024 ^ 2)
    fres[["JSHeapUsedSize"]] <- metrics[["JSHeapUsedSize"]] / (1024 ^ 2)
    
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
      
      usertime <- metrics[22]
      memory <- metrics[27]
      
      fres[["time"]] <- (as.numeric(strsplit(usertime, ":")[[1]][5]) * 60) + as.numeric(strsplit(usertime, ":")[[1]][6])
      
      fres[["maxResidentSetSize"]] <- as.numeric(strsplit(memory, ":")[[1]][2]) / (1024 ^ 1)
      
      results[[file.path(dir, d, r)]] <- fres
      
    } 
  }
  
  as.data.frame(do.call(rbind, lapply(results, as.vector)))
  
}

df_app <- process_app_results("./app-results")
df_cli <- process_cli_results("./cli-results")


library(dplyr)
library(tidyr)
library(plotrix)

rownames(df_app) <- NULL

res <- df_app %>% 
  unnest() %>%
  select(dataset, time, WasmMemory) %>%
  group_by(dataset) %>% 
  summarise_each(funs(mean, std.error))

write.table(as.data.frame(res), file="app_times.csv", row.names = FALSE)

rownames(df_cli) <- NULL

res <- df_cli %>% 
  unnest() %>%
  select(dataset, time, maxResidentSetSize) %>%
  group_by(dataset) %>% 
  summarise_each(funs(mean, std.error))

write.table(as.data.frame(res), file="cli_times.csv", row.names = FALSE)


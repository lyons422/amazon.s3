library("devtools")
library(roxygen2)
library(aws.s3)
library(dplyr)
setwd("/Users/zhengdaosong")
create("amazon.s3")



get_file <- function(access_key_id, access_key, bucket_name, folder){
  
  Sys.setenv("AWS_ACCESS_KEY_ID" = access_key_id,
             "AWS_SECRET_ACCESS_KEY" = access_key,
             "AWS_DEFAULT_REGION" = "us-east-1")
  
  # List all files stored in S3
  files <- get_bucket(bucket = bucket_name, prefix =folder)
                     
  # Create an empty data frame to store file names
  file_list <- data.frame()
  for (i in 1:length(files)){
    check = try(files[[i]]$Key, silent=TRUE)
    if(isTRUE(class(check)!="try-error")){
      file_name <- data.frame(files[[i]]$Key)
      file_list <- rbind(file_list, file_name)
    }
    }
  ## Extact file name
  colnames(file_list) <- "file"
  # Remove the files that are not in the designated folder
  file_list <- subset(file_list, grepl(paste0(folder,'/'), file_list$file))
  file_list$file <- sub(paste0(folder,"/"), "", file_list$file)
  file_list <- subset(file_list, file != "")
}

rm(list = ls())

library(rdrop2) # dropbox

token <- readRDS('token.rds')
drop_acc(dtoken = token)
drop.dir <- '2017.registration'

wd.root <- 'C:/Users/gbal/Desktop/github.work/shiny.registration.form/'
wd.analysis <- paste0(wd.root, 'registration.forms.analysis')

# dowloading files --------------------------------------------------------------

files.to.download <- drop_dir(drop.dir)$name

# folder to download answers
download.folder <- paste0(wd.analysis, '/forms.downloaded')
unlink(download.folder, recursive = TRUE, force = TRUE)
dir.create(download.folder)

for(f in 1:length(files.to.download)){
  #file.details <- drop_search(files.to.download[f])
  #drop_download(file.details$matches[[1]]$metadata$path_lower, 
  #              local_path = paste0(download.folder, '/', files.to.download[f]))
  drop_download(paste0(drop.dir, '/', files.to.download[f]),
                local_path = paste0(download.folder, '/', files.to.download[f]))
}
  
# create big list from files ---------------------------------------------------------

responses <- list()
for(f in 1:length(files.to.download)){
  responses[[f]] <- get(load(paste0(download.folder, '/', files.to.download[f])))
  names(responses)[f] <- gsub(files.to.download[f], pattern = '.RData', replacement = '')
}

#sapply(responses, '[[', 1)
#sapply(responses, '[[', 'surname')
sapply(responses, '[[', 'title')
sapply(responses, '[[', 'title.long')
#sapply(responses, '[[', 'authors.long')
#print(responses, right = FALSE)
#`Elvira .de eyto.09.34.47`
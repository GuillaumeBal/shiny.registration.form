rm(list = ls())

library(rdrop2) # dropbox

token <- readRDS('token.rds')
drop_acc(dtoken = token)
drop.dir <- '2019MiJttRegistration/0.applications'

wd.root <- 'C:/Users/gbal/Desktop/github.work/shiny.registration.form/2.jim.time.series/'
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


for(p in 1:length(responses)){
  cat(names(responses)[p])
  cat("  \n")
  cat(responses[[p]]['address'])
  cat("  \n")
}
#responses[[p]] %>% names()

sapply(responses, `[`, 'application') 
sapply(responses, `[`, 'email') %>% `[`(duplicated(.) %>% `!`) %T>% {print(length(.))} %>% paste(., collapse = ';')


Louise.Vaughan.10.38.03 %>% names
sapply(responses, `[`, 'lunch') %>% `==`("TRUE") %>% sum
sapply(responses, `[`, 'dinner') %>% `==`("TRUE") %>% sum

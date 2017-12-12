rm(list = ls())

#install.packages('rdrop2')
require(rdrop2)

#wd <- "C:/Users/gbal/Desktop/github.work/shiny.registration.form/0.sandbox"
#setwd(wd)

#drop_auth()
# This will launch your browser and request access to your Dropbox account. You will be prompted to log in if you aren't already logged in.
# Once completed, close your browser window and return to R to complete authentication. 
# The credentials are automatically cached (you can prevent this) for future use.

# If you wish to save the tokens, for local/remote use
#token <- drop_auth()
#saveRDS(token, file = "token.rds")

token <- readRDS('token.rds')
drop_acc(dtoken = token)

outputs.dir <- '2017.registration'
#drop_create('outputs.dir)
drop_dir(outputs.dir)
file.name <- 'mtcars.csv'
file.dir <- file.path(tempdir(), file.name)
write.csv(get(unlist(strsplit(file.name, split = '[.]'))[1]), file.dir)
drop_upload(file.dir, path = '2017.registration')
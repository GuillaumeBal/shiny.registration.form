#names(Hans.Gerritsen.13.57.53)

# interest names in R script
interests <- c('pop', 'life', 'management', 'env', 'gis', 'design')

# full names of interestest
interests.full <- c('Population dynamics', 'Life history trait, Evolution, genetics',
                 'Management advice', 'Environmental change, modelling',
                 'GIS', 'Survey design')

# matrix with ranking per person
interests.ranks <- matrix(NA,
                       nrow = length(responses), # persons
                       ncol = length(interests))

# fill matrix
for(g in 1:length(interests)){
  interests.ranks[ , g] <- sapply(responses, '[[', interests[g])
}


# isolate 3 main for one person
#paste0('Main interests: ',
#       paste(sapply(1:3, 
#                    function(i){
#                      interests.full[which(interests.ranks[1, ] == i)]
#                    }),
#             collapse = ' / ')
#)

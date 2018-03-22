rm(list = ls())

#install.packages("ReporteRs")
require(ReporteRs)

# get from dropbox =====================================
source('get.from.dropbox.r')

# suppress duplicated right here =======================

char.to.keep <- nchar(names(responses)) - 8
names.check <- substring(names(responses), 1, char.to.keep)
# alphabetical order then time, keep the last tone
to.supress <- which(duplicated(names.check)) - 1  
# subset responses
responses[to.supress] <- NULL

# create word document =================================

doc <- docx()

#names(responses[[1]])

for(p in 1:length(responses)){
  doc <- addTitle(doc,
                  value = paste(responses[[p]]['name'],
                                responses[[p]]['middlename'],
                                responses[[p]]['surname']),
                  level = 1)
  doc <- addParagraph(doc,
                      value = responses[[p]]['address'])
  # if a title add presentation details
  if(responses[[p]]['title'] != ''){
    doc <- addTitle(doc,
                    value = responses[[p]]['title'],
                    level = 2)
    doc <- addParagraph(doc,
                        value = responses[[p]]['abstract'])
    doc <- addParagraph(doc,
                        value = responses[[p]]['keywords'])
  }
  # if a title add presentation details
  if(responses[[p]]['title.long'] != ''){
    doc <- addTitle(doc,
                    value = paste('LONG - ', responses[[p]]['title.long']),
                    level = 2)
    doc <- addParagraph(doc,
                        value = responses[[p]]['abstract.long'])
    doc <- addParagraph(doc,
                        value = responses[[p]]['keywords.long'])
  }
}

writeDoc(doc, file = "registrations.details.2.docx")
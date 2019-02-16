rm(list = ls())

#install.packages("ReporteRs")
require(ReporteRs)

# get from dropbox =====================================
source('get.from.dropbox.r')

# create word document ==================================

doc <- docx()

for(p in 1:length(responses)){
  if(p == 1){
    doc <- addTitle(doc,
                    value = paste(responses[[p]]['name'],
                                  responses[[p]]['surname']),
                    level = 1)
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
                      value = responses[[p]]['title.long'],
                      level = 2)
      doc <- addParagraph(doc,
                          value = responses[[p]]['abstract.long'])
      doc <- addParagraph(doc,
                          value = responses[[p]]['keywords.long'])
    }
    
  }else{ # remove multiple sub 
    if(substring(names(responses)[p], 1, 10) != substring(names(responses)[p - 1], 1, 10)){
      doc <- addTitle(doc,
                      value = paste(responses[[p]]['name'],
                                    responses[[p]]['surname']),
                      level = 1)
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
                        value = responses[[p]]['title.long'],
                        level = 2)
        doc <- addParagraph(doc,
                            value = responses[[p]]['abstract.long'])
        doc <- addParagraph(doc,
                            value = responses[[p]]['keywords.long'])
      }
    }
    
    #cat(responses[[p]]['title'])
  }
  
}

writeDoc(doc, file = "registrations.details.docx")
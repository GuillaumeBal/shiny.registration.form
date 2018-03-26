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

# order list by surnames ==============================

responses <- responses[order(sapply(responses, '[[', 'surname'))]

#sapply(responses, '[[', 'surname')

# create word document =================================

doc <- docx(title = 'Environmetrics meeting, 
            April 25th-26th 2018')

# styles(doc)

# table orf content
doc <- addTOC(doc)

# page break
doc <- addPageBreak(doc)

# page numbers
doc <- addPageNumber(doc)

#names(responses[[1]])

# program ==================================================

doc <- addTitle(doc,
                level = 1,
                value = 'Program')

doc <- addTitle(doc,
                level = 2,
                value = 'Day 1')

doc <- addParagraph(doc,
                    value = c('9-10am, registration & coffee',
                              '10-10.30am, welcoming',
                              '10-11.30am, talks 1-5',
                              '11.30-12am, coffee break',
                              '12am-1pm, talks 6-10',
                              '1-2.30pm, lunch break', 
                              '2.30-3.30pm, talks 11-15',
                              '3.30-4pm, coffee break', 
                              '4-5pm,talks talks 16-20'),
                    stylename = "BulletList")

doc <- addTitle(doc,
                level = 2,
                value = 'Social diner')

doc <- addParagraph(doc,
                    value = c('The social diner will be in Tribeton at 6.30pm'))

doc <- addTitle(doc,
                level = 2,
                value = 'Day 2')

doc <- addParagraph(doc,
                    value = c('10-12am, TMB workshop',
                              '12-1.30pm, lunch break',
                              '1.30-2.15pm, long talk 1',
                              '2.15-3pm, long talk 2',
                              '3-3.30pm, coffee break',
                              '3.30-4pm, meeting debriefing and next steps'),
                    stylename = "BulletList")

# list summaries short =====================================

doc <- addPageBreak(doc)

doc <- addTitle(doc,
                level = 1,
                value = 'Abstracts')

for(p in 1:length(responses)){
  # if a title add presentation details
  if(responses[[p]]['title'] != '' & responses[[p]]['surname'] != 'Jackson'){
    print(p)
    doc <- addTitle(doc,
                    value = responses[[p]]['title'],
                    level = 2)
    doc <- addParagraph(doc,
                        value = unlist(strsplit(responses[[p]]['authors'], split = '\n')),
                        stylename = "BulletList")
    doc <- addParagraph(doc,
                        value = responses[[p]]['abstract'])
    doc <- addParagraph(doc,
                        value = paste0('Keywords:' ,responses[[p]]['keywords']),
                        stylename = "Citation")
  }
}

# list summaries long =====================================

doc <- addPageBreak(doc)

doc <- addTitle(doc,
                level = 1,
                value = 'Abstracts long presentations')

for(p in 1:length(responses)){
  # if a title add presentation details
  if(responses[[p]]['title.long'] != '' & responses[[p]]['surname'] != 'Khalil'){
    print(p)
    if(responses[[p]]['authors.long'] != ''){
      doc <- addTitle(doc,
                      value = responses[[p]]['title.long'],
                      level = 2)
      doc <- addParagraph(doc,
                          value = unlist(strsplit(responses[[p]]['authors.long'], split = '\n' )),
                          stylename = "BulletList")
      doc <- addParagraph(doc,
                          value = responses[[p]]['abstract.long'])
      doc <- addParagraph(doc,
                          value = paste0('Keywords:' ,responses[[p]]['keywords.long']),
                          stylename = "Citation")
    }else{
      doc <- addTitle(doc,
                      value = responses[[p]]['title'],
                      level = 2)
      doc <- addParagraph(doc,
                          value = unlist(strsplit(responses[[p]]['authors'], split = '\n' )),
                          stylename = "BulletList")
      doc <- addParagraph(doc,
                          value = responses[[p]]['abstract'])
      doc <- addParagraph(doc,
                          value = paste0('Keywords:' ,responses[[p]]['keywords']),
                          stylename = "Citation")
    }
  }
}

# TMB workshop details =======================================

doc <- addPageBreak(doc)

doc <- addTitle(doc,
                level = 1,
                value = 'TMB workshop')

doc <- addTitle(doc,
                level = 2,
                value = 'What is TMB and what can it do for me')

doc <- addParagraph(doc,
                    value = 'Template Model Builder is an exciting analytical tool for fitting high-dimensional, 
potentially non-linear statistical models. Inspired by ADMB, 
TMB is written in C++ and automatically differentiates the objective function, thus providing gradients that result in fast and stable optimization. This workshop will provide a practical introduction to TMB for ecological modelling, 
including a hands-on tutorial.)
')

doc <- addTitle(doc,
                level = 2,
                value = 'TMB setup')

doc <- addParagraph(doc,
                    value = 'This is what you need to do to get ready for the course')

# list of participants =====================================

doc <- addPageBreak(doc)

doc <- addTitle(doc,
                level = 1,
                value = 'List of participants')

for(p in 1:length(responses)){
  #doc <- addTitle(doc,
  #value = paste(responses[[p]]['name'],
  #              responses[[p]]['middlename'],
  #              responses[[p]]['surname']),
  #level = 2)
  doc <- addParagraph(doc,
                      value = paste(responses[[p]]['name'],
                                    responses[[p]]['middlename'],
                                    responses[[p]]['surname']),
                      stylename =  "Citationintense")
  doc <- addParagraph(doc,
                      value = responses[[p]]["address"])
  doc <- addParagraph(doc, 
                      value = responses[[p]]["email"])
}

# Organisation details ===================================

doc <- addPageBreak(doc)

doc <- addTitle(doc,
                level = 1,
                value = 'general details')

doc <- addTitle(doc,
                level = 2,
                value = 'Marine Institute')

doc <- addParagraph(doc,
                    value = c('Rinville, Oranmore, Co. Galway,H91 R673',
                              'Phone: (+)353 (0)9 138 7200',
                              'Fax (+)353 (0)9 138 7201',
                              'Email: institute.mail@marine.ie'))

doc <- addImage(doc,
                filename = 'mi.location.png',
                width = 5,
                height = 5)

doc <- addPageBreak(doc)

doc <- addTitle(doc,
                level = 2,
                value = 'Tribeton diner')

doc <- addParagraph(doc,
                    value = '1-3 Merchants Rd, Galway')

doc <- addImage(doc,
                filename = 'dinner.location.png',
                width = 6,
                height = 5)

# make documents =============================================

writeDoc(doc, file = "proceedings.docx")
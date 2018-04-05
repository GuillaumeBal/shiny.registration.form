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

# food details =========================================

n.dinners <- sum(as.logical(sapply(responses, '[[', 'dinner')))

sapply(responses, '[[', 'lunch')

sapply(responses, '[[', 'vegan')

n.vegan.dinners <- sum(as.logical(sapply(responses, '[[', 'dinner')) &
                         as.logical(sapply(responses, '[[', 'vegan')))


# create word document =================================

doc <- docx(title = 'Food environmetrics')

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


# make documents =============================================

writeDoc(doc, file = "food.docx")
abstracts <- sapply(responses, '[[', 'abstract')
titles <- sapply(responses, '[[', 'title')

sum(abstracts != '')

titles[titles != '']

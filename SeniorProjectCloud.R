library(tm) #text mining package

library(wordcloud)

directory <- paste0(getwd(),"/","Senior Project")

senPro <- Corpus(DirSource(directory))

senPro  <- tm_map(senPro , stripWhitespace)

senPro  <- tm_map(senPro , tolower)

senPro  <- tm_map(senPro ,removeWords,stopwords("en"))


wordcloud(senPro)

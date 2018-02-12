library(readr)
library(tm)
library(SnowballC)
library(RColorBrewer)
library(wordcloud)
library(ggplot2)
library(DescTools)
#loan <- read_csv("~/Documents/DS_IUB/DataViz/Project/Project1/lending-club-loan-data/loan_filtered.csv")
View(loan) 
purpose <- loan$purpose 
title <- loan$emp_title
Desc(title)
tbl=table(title)
write.csv(tbl,"tbl.csv")
title2 <- title[!is.na(title)]
#to remove emojis
title2 <- iconv(title2, 'UTF-8', 'ASCII')
#VectorSource() function creates a corpus of character vectors
docs <- Corpus(VectorSource(title2))
inspect(docs)

#Replacing "_" with space:

toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))
#docs <- tm_map(docs, toSpace, "_")

# Convert the text to lower case
docs <- tm_map(docs, content_transformer(tolower))
# Remove numbers
docs <- tm_map(docs, removeNumbers)
# Remove english common stopwords
docs <- tm_map(docs, removeWords, stopwords("english"))
# Remove your own stop word
# specify your stopwords as a character vector
docs <- tm_map(docs, removeWords, c("blabla1", "blabla2")) 
# Remove punctuations
docs <- tm_map(docs, removePunctuation)
# Eliminate extra white spaces
docs <- tm_map(docs, stripWhitespace)

######## Build term document matrix #######
dtm <- TermDocumentMatrix(docs)
m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)
head(d, 30)

######## Generate Word Cloud ########
set.seed(1234)
wordcloud(words = d$word, freq = d$freq,min.freq = 1,
          max.words=200, random.order=FALSE, rot.per=0.30, 
          colors=brewer.pal(8, "Dark2"))


###### Who all are applying for loans ######
loaner <- loan$emp_title

Desc(loaner, plotit=T, main="loanee_title")

Desc(data1$title, plotit=F)
a <- ggplot2(loaner, aes(hwy)) + geom_dotplot(data = loaner)


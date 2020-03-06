#Coursera John Hopkins Data Science
#Server File for Word Prediction Application

#Load Required Packages
library(shiny)
library(quanteda)
library(data.table)
library(dplyr)

#Read in ngram data files

setwd("/Users/ashleycampisano/Documents")
UnigramProb <- fread("GitHub/Data-Science-Capstone/UnigramProb.csv", header = T, sep = ",")
BigramProb <- fread("GitHub/Data-Science-Capstone/BigramProb.csv", header = T, sep = ",")
TrigramProb <- fread("GitHub/Data-Science-Capstone/TrigramProb.csv", header = T, sep = ",")
FourgramProb <- fread("GitHub/Data-Science-Capstone/FourgramProb.csv", header = T, sep = ",")

#Create function to predict next word when given a phrase
predictNextWord <- function(sentence, choices=NULL) {
    
    #Clean up input phrase
    sentenceToken <- as.character(tokens(tolower(sentence), removeNumbers = TRUE, removePunct = TRUE, 
                              removeSeparators = TRUE, removeSymbols = TRUE, removeTwitter = TRUE, 
                              removeHyphens = TRUE, what="fasterword", simplify = TRUE))
    
    #Check if entered text is valid and display a message
    if (length(sentenceToken) == 0) {
        return("App is ready. Please enter a phrase with valid characters in the textbox.")
    } else {
        #Start Predicting Next Word
        
        #Initialize empty data frame to hold the next word predictions
        match <- data.frame(Next=character(), MLEProb=numeric())
        
        #Attempt to match to a 4-gram if sentence has 3 or more words using MLE 
        if (length(sentenceToken) >= 3) {
            lastTrigram <- paste0(sentenceToken[length(sentenceToken)-2], " ",
                                  sentenceToken[length(sentenceToken)-1], " ", 
                                  sentenceToken[length(sentenceToken)])
            match <- filter(FourgramProb, lastTrigram==Trigram) %>% 
                arrange(desc(MLEProb))  %>% 
                top_n(5, MLEProb) %>% select(Next, MLEProb)
        }
        
        #If sentence has only 2 words or if match has less than 5 results
        if (length(sentenceToken) >= 2 | nrow(match) < 5) {
            lastBigram <- paste0(sentenceToken[length(sentenceToken)-1], " ", sentenceToken[length(sentenceToken)])
            x <- filter(TrigramProb, lastBigram==Bigram) %>% top_n(5, MLEProb) %>% 
                select(Next, MLEProb) %>% mutate(MLEProb=MLEProb*0.4) 
            match <- filter(x, !(Next %in% match$Next)) %>% bind_rows(match)
        }
        
        #If sentence has only 1 word or if match has less than 5 results
        if (length(sentenceToken) == 1 | nrow(match) < 5){
            lastWord <- sentenceToken[length(sentenceToken)]
            x <- filter(BigramProb, lastWord==Prev) %>%  top_n(5, MLEProb) %>%
                select(Next, MLEProb) %>% mutate(MLEProb=MLEProb*0.4*0.4)
            match <- filter(x, !(Next %in% match$Next)) %>% bind_rows(match)
        } 
        
        #If Bigram match has failed, if match has less than 5 results
        if (nrow(match) < 5){
            x <- top_n(UnigramProb, 5, KNProb) %>% select(Next, KNProb) %>% 
                mutate(MLEProb=KNProb*0.4*0.4*0.4)
            match <- filter(x, !(Next %in% match$Next)) %>% bind_rows(match)
        } 
        
        #Sort matches by MLE
        match <- arrange(match, desc(MLEProb))
        
        return(paste0(sentence, " ", match$Next))
    }
}

#Show predicted next word for phrase in UI
shinyServer(function(input, output) {
    output$predictedsentence <- renderText({ 
        text <- predictNextWord(input$words) 
        paste(text, collapse = "\n")
        })
    
    output$wordcloud <- renderPlot({
        par(mfrow=c(1,3))
        wordcloud(top3$Trigram, top3$TrigramFreq, scale=c(3,.3), colors=(brewer.pal(8, 'Dark2')))
        wordcloud(top2$Bigram, top2$BigramFreq, scale=c(3,.3), colors=(brewer.pal(8, 'Dark2')))   
    })
})

#Coursera John Hopkins Data Science
#UI File for Word Prediction Application

#Load Required Packages

library(shiny)
library(markdown)
library(shinythemes)

shinyUI(fluidPage(theme=shinytheme("cyborg"),
  
  titlePanel("Word Prediction Application"),
  
  img(src = "cap_logo.png", height = 80, width = 1000),
  
  #Side bar with instructions for using the app
  sidebarLayout(position = "right",
    sidebarPanel(
        h3("Application Function"),
        p("This application will predict the next word for any phrase that is typed into the phrase box to the left."),
        h3("User Instructions"),
        p("Wait the ''App is ready'' message pops up then  
          begin typing your phrase. The message may take a few seconds to show up."),
        p("Your input phrase along with the predicted next words will be shown below the textbox as 
          you start typing."),
        p("The application is unable to give predictions if only numbers or symbols are typed in to the phrase box."),
    ),
    
    mainPanel(
        tabsetPanel(type = "tabs", 
                    tabPanel("Word Prediction",
                             br(),
                             textInput('words', label="Type your phrase below", width = "100%"),
                             verbatimTextOutput('predictedsentence')
                             )
        )
    )
  )
))


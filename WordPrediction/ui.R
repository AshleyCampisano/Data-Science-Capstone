#Coursera John Hopkins Data Science
#UI File for Word Prediction Application

#Load Required Packages

library(shiny)
library(markdown)
library(shinythemes)


shinyUI(fluidPage(theme=shinytheme("superhero"),
  
  titlePanel("Word Prediction Application"),
  
  img(src = "SwiftKey_logo.jpeg", height = 140, width = 400),
  
  #Side bar with instructions for using the app
  sidebarLayout(position = "right",
    sidebarPanel(
        h3("Application Function"),
        p("This application will predict the next word for any phrase that is typed into the phrase box to the left."),
        h3("User Instructions"),
        p("On the ''Word Predictions'' tab, wait until you see the ''App is ready'' message then  
          begin typing the phrase you want to get a prediction for. You may need to wait for 
          10-20 seconds for the message to appear."),
        p("Your input phrase along with suggested next words will be shown below the textbox as 
          you start typing."),
        p("The application is unable to give predictions if only numbers or symbols are typed in to the phrase box."),
    ),
    
    #Main panel with tabs containing the text prediction app and a separate tab for app details
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

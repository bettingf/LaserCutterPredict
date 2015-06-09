library(shiny)

sellers<-read.csv("sellers.csv",
                  stringsAsFactors = FALSE)
material<-read.csv("material.csv",
                   stringsAsFactors = FALSE)

shinyUI(fluidPage(
    uiOutput("title"),
    sidebarLayout(  
      sidebarPanel(
        radioButtons("lang", "Language :",
                     choices=c("english","francais")),
        hr(),
        uiOutput("ui")
      ),
      mainPanel(
        p("output"),
        plotOutput("plot"),
        uiOutput("main")
      )
    )
  )
)
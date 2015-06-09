library(shiny)

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
        tabsetPanel(  
          tabPanel(textOutput("tabTable"), uiOutput("main")),
          tabPanel(textOutput("tabGraph"), plotOutput("plot")),
          tabPanel(textOutput("tabPredict"), uiOutput("predict")))
      )
    )
  )
)
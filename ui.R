library(shiny)


shinyUI(fluidPage(
    uiOutput("title"),
    helpText(a("Help", href="http://bettingf.github.io/LaserCutterPredict/LaserCuttingPredict.html")),
    sidebarLayout(  
      sidebarPanel(
        radioButtons("lang", "Language :",
                     choices=c("english","francais")),
        hr(),
        uiOutput("ui")
      ),
      mainPanel(
        tabsetPanel(  
          tabPanel(textOutput("tabPredict"), uiOutput("predict")),
          tabPanel(textOutput("tabParam"), uiOutput("param")),
          tabPanel(textOutput("tabGraph"), plotOutput("plot")),
          tabPanel(textOutput("tabData"), uiOutput("main"))
        )
      )
    )
  )
)
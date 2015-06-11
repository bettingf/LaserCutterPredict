library(shiny)


shinyUI(fluidPage(
    uiOutput("title"),
    flowLayout(
      downloadLink('downloadHelp','User manual'),
      downloadLink('downloadData','Data download')
    ),
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
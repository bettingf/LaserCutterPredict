library(shiny)
library(ggplot2)
library(reshape2)

sellers<-read.csv("sellers.csv",
                  stringsAsFactors = FALSE)
material<-read.csv("material.csv",
                   stringsAsFactors = FALSE)
tr<-read.csv("translations.csv",
             stringsAsFactors = FALSE)



trDisp <- function(id, lang) {
  tr[tr$id==id,lang]
}

shinyServer(
   
  function(input, output, session) {
    #reactive(print(input$lang))
    
    output$sellers <- renderTable(sellers)
    output$material <- renderTable(material)
    output$lang <- reactive({input$lang})
    
    #UI
    output$title <- renderUI(
      titlePanel(trDisp("title", input$lang))
    )
    
    output$ui <- renderUI(
      fluidRow(
      selectInput("seller", 
                  trDisp("seller:",input$lang), 
                  choices = sellers$Sellers),
      selectInput("material", 
                  trDisp("material:",input$lang), 
                  choices = material$Materials),
      textInput("thickness", 
                trDisp("thickness:",input$lang)),
      hr(),
      dateInput("date", 
                trDisp("date:",input$lang)),
      textInput("speed", 
                trDisp("speed:",input$lang)),
      
      textInput("minpuiss", 
                trDisp("minpuiss:",input$lang)),
      
      textInput("maxpuiss", 
                trDisp("maxpuiss:",input$lang)),
      hr(),     
      actionButton("showButton", 
                   trDisp("show",input$lang)),
      actionButton("addButton", 
                   trDisp("add",input$lang)),
      actionButton("predictButton", 
                   trDisp("predict",input$lang))
      )
    )
    
    
    observeEvent(input$addButton, {
      
      data<-read.csv("parameters.csv",
                     stringsAsFactors = FALSE)
      
      t<-data.frame(date=toString(input$date), 
                    seller=input$seller, 
                    material=input$material, 
                    thickness=input$thickness, 
                    speed=input$speed, 
                    minpuiss=input$minpuiss, 
                    maxpuiss=input$maxpuiss)
      str(t)
      str(data)
      data<-rbind(data,t)
      
      str(data)
      write.csv(data,"parameters.csv", row.names=FALSE)
      
      data<-read.csv("parameters.csv",
                     stringsAsFactors = FALSE)
      
      names(data) <- sapply(names(data), 
          function(x) { trDisp(x,input$lang)})
      
      output$main <- renderUI(
        fluidRow(
          renderTable(data)
        )
      )
      
    })
    
    observeEvent(input$showButton, {
      
      data<-read.csv("parameters.csv",
                     stringsAsFactors = FALSE)
      
      names(data) <- sapply(names(data), 
                            function(x) { trDisp(x,input$lang)})
      
      output$main <- renderUI(
        fluidRow(
          renderTable(data)
        )
      )
      
    })
    
    observeEvent(input$predictButton, {
      data<-read.csv("parameters.csv",
                     stringsAsFactors = FALSE)
      d<-data[data$material==input$material&data$thickness==input$thickness,]
      dMelt<-melt(d,measure.vars=c("minpuiss", "maxpuiss"), id.vars=c("speed"))           
      
      output$plot <- renderPlot({
        qplot(speed, value, data=dMelt, col=variable, geom=c("point", "smooth"), method="lm",xlab="vitesse", ylab="puissance")
      })
    })
    
  }      
)
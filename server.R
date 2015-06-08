library(shiny)

sellers<-read.csv("sellers.csv",
                  stringsAsFactors = FALSE)
material<-read.csv("material.csv",
                   stringsAsFactors = FALSE)
tr<-read.csv("translations.csv",
             stringsAsFactors = FALSE)
con1 <- file("parameters.csv")
data<-read.csv(con1,
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
                  trDisp("seller",input$lang), 
                  choices = sellers$Sellers),
      selectInput("material", 
                  trDisp("material",input$lang), 
                  choices = material$Materials),
      textInput("thickness", 
                trDisp("thickness",input$lang)),
      hr(),
      dateInput("date", 
                trDisp("date",input$lang)),
      textInput("speed", 
                trDisp("speed",input$lang)),
      
      textInput("minpuiss", 
                trDisp("minpuiss",input$lang)),
      
      textInput("maxpuiss", 
                trDisp("maxpuiss",input$lang)),
      hr(),     
      actionButton("addButton", 
                   trDisp("add",input$lang)),
      actionButton("predictButton", 
                   trDisp("predict",input$lang))
      )
    )
    
    
    observeEvent(input$addButton, {
      
      
      print("add")
      print(input$addButton)
      print(input$predictButton)
      
      
      t<-data.frame(date=input$date, 
                    seller=input$seller, 
                    material=input$material, 
                    thickness=input$thickness, 
                    speed=input$speed, 
                    minpuiss=input$minpuiss, 
                    maxpuiss=input$maxpuiss)
      print(names(t))
      print(dim(t))
      print("----")
      print(names(data))
      print(dim(data))
      
      data2 <- data
      data<-rbind(t,data2)
      
      con <- file("parameters.csv")
      write.csv(data,con, row.names=FALSE)
      
      data<-NULL
      con <- file("parameters.csv")
      data<-read.csv(con,
                     stringsAsFactors = FALSE)
      
      print(dim(data))
      
      output$main <- renderUI(
        fluidRow(
          renderTable(data)
        )
      )
      
      print(dim(data))
    })
    
    observeEvent(input$predictButton, {
      
      print("predict")
      print(input$addButton)
      print(input$predictButton)
      
      
      t<-data.frame(date=input$date, 
                    seller=input$seller, 
                    material=input$material, 
                    thickness=input$thickness, 
                    speed=input$speed, 
                    minpuiss=input$minpuiss, 
                    maxpuiss=input$maxpuiss)
      print(names(t))
      print(dim(t))
      print("----")
      print(names(data))
      print(dim(data))
      
      data<-rbind(t,data)
      
      con <- file("parameters.csv")
      write.csv(data,con, row.names=FALSE)
      
      data<-NULL
      con <- file("parameters.csv")
      data<-read.csv(con,
                     stringsAsFactors = FALSE)
      
      print(dim(data))
      
      output$main <- renderUI(
        fluidRow(
          renderTable(data)
        )
      )
      
      print(dim(data))
    })
    
  }      
)
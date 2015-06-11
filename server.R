library(shiny)
library(ggplot2)
library(reshape2)

sellers<-read.csv("sellers.csv",
                  stringsAsFactors = FALSE)
material<-read.csv("material.csv",
                   stringsAsFactors = FALSE)
cuttypes<-read.csv("cuttypes.csv",
                   stringsAsFactors = FALSE)
tr<-read.csv("translations.csv",
             stringsAsFactors = FALSE)

trDisp <- function(id, lang) {
  tr[tr$id==id,lang]
}

predictByThickness <- function(input, output, session) {
  
  data<-read.csv("parameters.csv",
                 stringsAsFactors = FALSE)
  
  d<-data[data$material==input$material&data$cuttype==input$cuttype&!is.na(data$minpuiss)&!is.na(data$maxpuiss),]
 
  speedFit<-lm(speed~thickness, data = d)
  minFit<-lm(minpuiss~thickness, data = d)
  maxFit<-lm(maxpuiss~thickness, data = d)
  thicknesses<-seq(1,10,1)
  speeds<-predict(speedFit, newdata = data.frame(thickness=thicknesses))
  mins<-predict(minFit, newdata = data.frame(thickness=thicknesses))
  maxs<-predict(maxFit, newdata = data.frame(thickness=thicknesses))
  data2<-data.frame(thickness= thicknesses, speed=speeds, minpuiss=mins, maxpuiss=maxs)
  # keep only the meaningful values (100>=power>=10 and max>=min)
  data2<- data2[data2$maxpuiss<=100&data2$maxpuiss>=data2$minpuiss&data2$minpuiss>=10&data2$speed>0,]
  
  names(data2)<-lapply(names(data2), 
                       function(x) { trDisp(x,input$lang)})
  
  output$predict <- renderUI(
    fluidRow(
      p(paste(input$cuttype,input$material)),
      h3(trDisp("thicknesspredict:",input$lang)),
      renderTable(data2)
    )
  )
}

showAndPredict <- function(input, output, session) {
  
  data2<-read.csv("parameters.csv",
                 stringsAsFactors = FALSE)
  
  # Order the data by material, thickness and then cut type.
  data2<-data2[order(data2$material, data2$thickness, data2$cuttype),]
  
  # check if it's needed
  data2<-data2[!is.na(data2$minpuiss)&!is.na(data2$maxpuiss),]
  
  names(data2) <- lapply(names(data2), 
                        function(x) { trDisp(x,input$lang)})
  
  output$main <- renderUI(
    fluidRow(
      renderTable(data2)
    )
  )
  
  data<-read.csv("parameters.csv",
                 stringsAsFactors = FALSE)
  
  d<-data[data$material==input$material&data$thickness==input$thickness&data$cuttype==input$cuttype&!is.na(data$minpuiss)&!is.na(data$maxpuiss),]
  names(d)<-c("date","seller","material","thickness","cuttype","speed","min","max")
  
  if (dim(d)[[1]]>1)
  {
  dMelt<-melt(d,measure.vars=c("min", "max"), id.vars=c("speed"))
  
  output$plot <- renderPlot({
    qplot(speed, value, data=dMelt, 
          col=variable, geom=c("point", "smooth"), 
          method="lm",
          xlab=trDisp("speed",input$lang), 
          ylab=trDisp("power",input$lang), 
          main=paste0(paste(input$cuttype,input$material,input$thickness),"mm")
          )+ theme(legend.title = element_blank())
          
  })
  
  minFit<-lm(min~speed, data = d)
  maxFit<-lm(max~speed, data = d)
  speeds<-c(seq(10,100,10),seq(200,1000,100))
  mins<-predict(minFit, newdata = data.frame(speed=speeds))
  maxs<-predict(maxFit, newdata = data.frame(speed=speeds))
  data3<-data.frame(speed=speeds, minpuiss=mins, maxpuiss=maxs)
  
  # keep only the meaningful values (100>=power>=10 and max>=min)
  data3<- data3[data3$maxpuiss<=100&data3$maxpuiss>=data3$minpuiss&data3$minpuiss>=10,]
  
  names(data3)<-lapply(names(data3), 
                       function(x) { trDisp(x,input$lang)})
  
  dMed <- d[d$speed == median(d$speed),]
  names(dMed)<-lapply(names(dMed), 
                       function(x) { trDisp(x,input$lang)})
  
  output$param <- renderUI(
    fluidRow(
      p(paste0(paste(input$cuttype,input$material,input$thickness),"mm")),
      # means
      h3(trDisp("meanvals:",input$lang)),
      p(paste(trDisp("meanspeed:",input$lang), mean(d$speed, na.rm = TRUE))),
      p(paste(trDisp("meanminpuiss:",input$lang), mean(d$min, na.rm = TRUE))),
      p(paste(trDisp("meanmaxpuiss:",input$lang), mean(d$max, na.rm = TRUE))),
      # values at median speed
      h3(trDisp("medianvals:",input$lang)),
      renderTable(dMed),
      #predictions
      h3(trDisp("powerneeded:",input$lang)),
      renderTable(data3)
    )
  )
  }
  
}
  

shinyServer(
   
  function(input, output, session) {
    #reactive(print(input$lang))
    
    output$sellers <- renderTable(sellers)
    output$material <- renderTable(material)
    output$lang <- reactive({input$lang})
    output$tabGraph <- reactive({trDisp("graph", input$lang)})
    output$tabData <- reactive({trDisp("data", input$lang)})
    output$tabPredict <- reactive({trDisp("prediction", input$lang)})
    output$tabParam <- reactive({trDisp("param", input$lang)})
    output$downloadData <- downloadHandler(
      filename = function() {
        paste('laserParams', Sys.Date(), '.csv', sep='')
      },
      content = function(file) {
        data<-read.csv("parameters.csv",
                       stringsAsFactors = FALSE)
        write.csv(data, file)
      }
    )
    output$downloadHelp <- downloadHandler(
      filename = function() {
        "LaserCuttingPredict.pdf"
      },
      content = function(file) {
        file.copy("LaserCuttingPredict.pdf", file)
      }
    )
      
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
      selectInput("cuttype", 
                trDisp("cuttype:",input$lang),
                choices = cuttypes$CutTypes),
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
                   trDisp("calculate",input$lang)),
      actionButton("addButton", 
                   trDisp("add",input$lang))
      )
    )
    
    
    observeEvent(input$addButton, {
      
      data<-read.csv("parameters.csv",
                     stringsAsFactors = FALSE)
      
      t<-data.frame(date=toString(input$date), 
                    seller=input$seller, 
                    material=input$material, 
                    thickness=input$thickness, 
                    cuttype=input$cuttype, 
                    speed=input$speed, 
                    minpuiss=input$minpuiss, 
                    maxpuiss=input$maxpuiss)
      str(t)
      str(data)
      data<-rbind(data,t)
      
      str(data)
      write.csv(data,"parameters.csv", row.names=FALSE)
      
      
      predictByThickness(input, output, session)
      showAndPredict(input, output, session)
      
    })
    
    observeEvent(input$showButton, {
      predictByThickness(input, output, session)
      showAndPredict(input, output, session)
    })
    
  }      
)
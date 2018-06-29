ipack <- function( pkg )
  
{
  new.pkg <-  pkg[ ! (pkg %in% installed.packages()[,"Package"]) ]
  if ( length(new.pkg) ) 
    install.packages(
      new.pkg, dependencies = TRUE )
  sapply( pkg, require, character.only = TRUE )
}


packs<- c( "tidyverse", "rmarkdown","xml2","ggmosaic",
           "plotly", "ggmap", "raster", "rgdal",
           "knitr", "scales", "lubridate", "devtools",
           "grid", "gridExtra", "shiny","shinythemes")
ipack(packs)

#Bases de datos
load("Database.RData")

ui <- fluidPage(theme = shinytheme("journal"),
   
   
   titlePanel(h2("Global production of Solar-Wind Electricity,  1990-2016")),

   tabsetPanel(
  
     
                                                  #TIMES SERIES      
     tabPanel(
       title=h4("Times Series"),
       hr(),
       
       sidebarLayout(
         
         
         sidebarPanel(
           
           selectInput("timeseriesbase","Electricity:",
                       choices =  list(
                         "Solar"="s.datos",
                         "Wind"="w.datos")),
           
           selectInput("timeseriescountry", "Choise country:",
                              choices = c(names( table(s.datos$c) )  ),multiple = T  )
         
        ), #sidebarPanel
       
       mainPanel(
         
         plotlyOutput("timeseries"),
         hr()
         
         ) #mainPanel
       
     
       )#sidebarLayout
       )#tabPanel
     
     
     
    )   #tabsetPanel
   

)#fluidPage/UI


server <- function(input, output) {
  
                                                                  #TIME SERIES
  timeseriesbaseInput<-reactive({  get (input$timeseriesbase) })
  timeseriescountryInput<-reactive({ input$timeseriescountry})
  
  output$timeseries<-renderPlotly({
    
    
    
    
    
    if(is.null(timeseriescountryInput() ))
    {
      ggplotly( timeseriesbaseInput() %>%
                  ggplot( aes(y,q) )+
                  geom_line(aes(group=c))+
                  labs(x="Years",y="Quantity in Kilowatt-hours, million")+
                  theme_minimal()
                )
    }
    else
      #selecciona un país
    {
    
    ggplotly( timeseriesbaseInput() %>% filter( c%in%timeseriescountryInput() ) %>%
               ggplot( aes(y,q) )+
               geom_line(aes(group=c))+
                labs(x="Years",y="Quantity in Kilowatt-hours, million")
              
              )
    }#else is.null(timeseriesbase)
    
  })#renderPlotly
  
  
  
}#SERVER



 
shinyApp(ui = ui, server = server)

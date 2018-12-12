#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(dplyr)
library(shiny)
library(ggplot2)
# cargo los archivos
df <- read.csv("~/ODH/datos_economia_social/10_economia_social_tabla2.csv")
# convierto los periodos en formato 'Date' dejando solo los anios
for (tt in 1:length(df$Periodo)) df$Periodo[tt] <- format(as.Date(paste0(as.character(df$Periodo[tt]),"01"),
                                                                  format = "%Y%m%d"),"%Y")
# Define server logic required to draw a histogram
server <- function(input, output) {
  output$distPlot <- renderPlot({
    serie <- df[,2:6] %>% filter(Programa==input$prog) %>% 
      filter(Sexo == input$sex) %>% group_by(Periodo) %>%
      arrange(Periodo) %>% filter(Provincia == input$prov) %>%
      unique()
    ggplot(serie) +
      geom_line(aes(x=Periodo,y=Titulares,colour=Programa))  
      # scale_color_discrete(name = "Programa", labels = c("AT", "EH")) +
      # geom_tile("Cantidad de titulares de los planes 2015-2017")
  })
  # 
  # output$distPlot <- renderPlot({
  #   # generate bins based on input$bins from ui.R
  #   x    <- faithful[, 2] 
  #   bins <- seq(min(x), max(x), length.out = input$bins + 1)
  #   
  #   # draw the histogram with the specified number of bins
  #   hist(x, breaks = bins, col = 'darkgray', border = 'white')
  # })
}
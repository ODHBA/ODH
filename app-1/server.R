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
library(magrittr)
library(ggplot2)
library(tidyr)
# cargo los archivos
df <- read.csv("~/ODH/datos_economia_social/10_economia_social_tabla2.csv")
# convierto los periodos en formato 'Date' dejando solo los anios
for (tt in 1:length(df$Periodo)) df$Periodo[tt] <- format(as.Date(paste0(as.character(df$Periodo[tt]),"01"),
                                                                  format = "%Y%m%d"),"%Y")
# nombres de la provincia
prov_names <- read.csv("~/ODH/datos_economia_social/10_economia_social_tabla2.csv") %>%
  distinct(Provincia)
prov_choices <- list()
for (ii in 1:dim(prov_names)[1]) {
  val <- prov_names$Provincia[ii]
  prov_choices[[as.character(val)]] <- prov_names$Provincia[ii]
}
# Define server logic required to draw a histogram
server <- function(input, output,session) {
  observe({
    x <- input$prog
    if (x=="EH") {
      updateCheckboxGroupInput(session,"sex",
                              choices = "F",
                              selected = "F")
    }
  })
  datos <- reactive({
    prov_sel <- input$prov
    sex_sel <- input$sex
    if (!is.null(input$prog) && !is.null(input$sex)) {
      serie <- df[,2:6] %>% filter(Programa==input$prog) %>% 
        filter(Sexo %in% sex_sel) %>% group_by(Periodo) %>%
        arrange(Periodo) %>% filter(Provincia %in% prov_sel) %>%
        unique()  
    } else if (!is.null(input$prog) && is.null(input$sex)) {
      serie <- df[,2:6] %>% 
        filter(Programa == input$prog) %>% group_by(Periodo) %>%
        arrange(Periodo) %>% filter(Provincia %in% prov_sel) %>% unique()
    } else if (!is.null(input$sex) && is.null(input$prog)) {
      serie <- df[,2:6] %>% 
        filter(Sexo %in% sex_sel) %>% group_by(Periodo) %>%
        arrange(Periodo) %>% filter(Provincia %in% prov_sel) %>%
        unique()
    } else {
      serie <- df[,2:6] %>% group_by(Periodo) %>%
        arrange(Periodo) %>% filter(Provincia %in% prov_sel) %>%
        unique()
    }
    })

output$distPlot <- renderPlot ({
p <- ggplot(data=datos()) +
    geom_line(aes(Periodo,Titulares,group=interaction(Provincia,Sexo),
                  colour=Provincia,linetype=Sexo)) +
                  geom_point(aes(Periodo,Titulares))
  p
})

}
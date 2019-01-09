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
df.aux <- read.csv("~/ODH/datos_economia_social/10_economia_social_tabla2.csv")
# convierto los periodos en formato 'Date' dejando solo los anios
for (tt in 1:length(df.aux$Periodo)) df.aux$Periodo[tt] <- format(as.Date(paste0(as.character(df.aux$Periodo[tt]),"01"),
                                                                  format = "%Y%m%d"),"%Y")
# elimino la primer columna que no me sirve 'X'
df.aux$X <- NULL
# nombres de la provincia
prov_names <- read.csv("~/ODH/datos_economia_social/10_economia_social_tabla2.csv") %>%
  distinct(Provincia)
prov_choices <- list()
for (ii in 1:dim(prov_names)[1]) {
  val <- prov_names$Provincia[ii]
  prov_choices[[as.character(val)]] <- prov_names$Provincia[ii]
}
# cargo los censos 2010
censo <- read.csv("~/ODH/datos_censos/censo_nombrecambiado.csv")
# elimino la primer columna que no me sirve 'X'
censo$X <- NULL
# combino ambos data frames
df_censo <- merge(censo,df.aux,by="Provincia")
# Define server logic required to draw a histogram
server <- function(input, output,session) {

  observe({
    
    x <- input$prog
    if (x=="EH") {
      updateCheckboxGroupInput(session,"sex",
                              choices = list("Mujeres"="F"),
                              selected = "F")
    } else {
      updateCheckboxGroupInput(session,"sex",
                               choices = list( "Mujeres" = "F",
                                               "Hombres" = "M"),
                               selected = "F")
    }
  })
  datos <- reactive({
    prov_sel <- input$prov
    sex_sel <- input$sex
    if (length(sex_sel)==0) {
      validate(
        need(sex_sel != "", "Por favor seleccione un género")
      )
    } else if (length(sex_sel) >1) {
      df <- data.frame(Programa=df_censo$Programa,Periodo=df_censo$Periodo,
                       Titulares=(df_censo$Titulares/(df_censo$Varones+df_censo$Mujeres))*100,
                       Sexo=df_censo$Sexo,Provincia=df_censo$Provincia)
    } else {
      if (sex_sel=="M") {
        df <- data.frame(Programa=df_censo$Programa,Periodo=df_censo$Periodo,
                         Titulares=(df_censo$Titulares/df_censo$Varones)*100,
                         Sexo=df_censo$Sexo,Provincia=df_censo$Provincia)
      } else if (sex_sel=="F") {
        df <- data.frame(Programa=df_censo$Programa,Periodo=df_censo$Periodo,
                         Titulares=(df_censo$Titulares/df_censo$Mujeres)*100,
                         Sexo=df_censo$Sexo,Provincia=df_censo$Provincia)
      } 
    }
    if (!is.null(input$prog) && !is.null(input$sex)) {
      serie <- df %>% filter(Programa==input$prog) %>%
        filter(Sexo %in% sex_sel) %>% group_by(Periodo) %>%
        arrange(Periodo) %>% filter(Provincia %in% prov_sel) %>%
        unique()
    } else if (!is.null(input$prog) && is.null(input$sex)) {
      serie <- df %>%
        filter(Programa == input$prog) %>% group_by(Periodo) %>%
        arrange(Periodo) %>% filter(Provincia %in% prov_sel) %>% unique()
    } else if (!is.null(input$sex) && is.null(input$prog)) {
      serie <- df %>%
       filter(Sexo %in% sex_sel) %>% group_by(Periodo) %>%
        arrange(Periodo) %>% filter(Provincia %in% prov_sel) %>%
        unique()
    } else {
      serie <- df %>% group_by(Periodo) %>%
        arrange(Periodo) %>% filter(Provincia %in% prov_sel) %>%
        unique()
    }
    })

output$distPlot <- renderPlot ({
p <- ggplot(data=datos()) +
    geom_line(aes(Periodo,Titulares,group=interaction(Provincia,Sexo),
                  colour=Provincia,linetype=Sexo)) +
                  geom_point(aes(Periodo,Titulares)) +
                  xlab("Año") + ylab("Titulares (%)")
  p
})

}
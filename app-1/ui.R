#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(magrittr)
library(dplyr)
library(shiny)

# abro el archivo '10_economia_social_tabla2.csv' para tomar los 
# nombres de la provincia
prov_names <- read.csv("~/ODH/datos_economia_social/10_economia_social_tabla2.csv") %>%
  distinct(Provincia)
prov_choices <- list()
for (ii in 1:dim(prov_names)[1]) {
  val <- prov_names$Provincia[ii]
  prov_choices[[as.character(val)]] <- ii
}
ui <- fluidPage(
  navbarPage(title = "Informes del ODH",
             tabPanel("Economía Social",
                      titlePanel("Economía Social"),
                      wellPanel(
                      fluidRow(
                          column(4,
                          checkboxGroupInput("sex",
                                             h3("Sexo"),
                          choices = list( "Mujeres" = "F",
                                          "Hombres" = "M"),
                      selected = "F")),
                     
                      
                      column(4,
                            selectInput("prov",
                                               h3("Seleccione la Provincia/s"),
                                               choices = prov_choices,
                                        width = '400px',
                                        selected = 2)  
                            ),
                      column(4,
                             checkboxGroupInput("prog",
                                                h3("Programa"),
                                                choices = list( "Arg. Trabaja" = "AT",
                                                                "Ellas Hacen" = "EH"),
                                                selected = c("AT","EH"))
                      )
                     )
                          
                          )),
             fluidRow(
               plotOutput("distPlot")
             ),
             tabPanel("Pers. en sit. calle","hola")
  )
)

# # Define UI for application that draws a histogram
# ui <- fluidPage(
#   
#   # Application title
#   titlePanel("Old Faithful Geyser Data"),
#   
#   # Sidebar with a slider input for number of bins 
#   sidebarLayout(
#     sidebarPanel(
#       sliderInput("bins",
#                   "Number of bins:",
#                   min = 1,
#                   max = 50,
#                   value = 30)
#     ),
#     
#     # Show a plot of the generated distribution
#     mainPanel(
#       plotOutput("distPlot")
#     )
#   )
# )
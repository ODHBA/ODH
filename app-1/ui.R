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
library(shinyWidgets)
# abro el archivo '10_economia_social_tabla2.csv' para tomar los 
# nombres de la provincia
prov_names <- read.csv("~/ODH/datos_economia_social/10_economia_social_tabla2.csv") %>%
  distinct(Provincia)
prov_choices <- list()
for (ii in 1:dim(prov_names)[1]) {
  val <- prov_names$Provincia[ii]
  prov_choices[[as.character(val)]] <- prov_names$Provincia[ii]
}
ui <- fluidPage(
  navbarPage(title = "Informes del ODH",
             tabPanel("Economía Social",
                      titlePanel("Economía Social"),
                      wellPanel(
                      fluidRow(
                          column(4,

                      selectInput("prog",
                                  h3("Programa"),
                                  choices = list( "Arg. Trabaja" = "AT",
                                                  "Ellas Hacen" = "EH"),
                                  selected = "AT")
                      ),
                     
                      # elijo multiple-choice, para seleccionar varias provincias
                      column(4,
                            pickerInput("prov",
                                               h3("Seleccione la Provincia/s"),
                                               choices = prov_choices,
                                        width = '200px',
                                        selected = 'CAPITAL_FEDERAL',multiple = TRUE)  
                            ),
                      column(4,
                             checkboxGroupInput("sex",
                                                h3("Sexo"),
                                                choiceNames = list( icon("Mujeres") ,
                                                                icon("Hombres")),
                                                choiceValues = list("F","M")
                                                )
                      )
                      # column(4,
                      #        selectInput("est",
                      #                           h3("Estadístico"),
                      #                           choices = list( "Absoluto" = "A",
                      #                                           "Relativo" = "R"),
                      #                           selected = "A")
                      # )
                     )
                          
                          ),
             fluidRow(
               plotOutput("distPlot")
             )),
             tabPanel("Pers. en sit. calle",titlePanel("¡PRÓXIMAMENTE!")),
             tabPanel("ESI",titlePanel("¡PRÓXIMAMENTE!"))
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
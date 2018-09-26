#' ---
#' title: "ODH - Censos"
#' author: "Noelia y Pablo"
#' date: "`r format(Sys.Date())`"
#' output: github_document
#' ---
#' 
#' ## OBJETIVO
#' https://www.engineeringbigdata.com/web-scraping-wikipedia-world-population-rvest-r/
#' Extraer datos de censos de wikipedia
#' 
#' ## DIRECTORIOS
DATOS <- "/home/noelia/MEGAsync/ODH/datos_censos/"
#' 
#' ## LIBRERIAS
library(rvest)
library(xml2)
library(magrittr)
library(qdap)

censo_wiki <- "https://es.wikipedia.org/wiki/Censo_argentino_de_2010" %>% read_html()
censo_wiki

#' ## CALCULOS
#' Encontrar XPath for html_nodes.
#' //*[@id="mw-content-text"]/div/table[2]
#' 
censo_prov_sex <- censo_wiki %>%
  html_nodes(xpath='//*[@id="mw-content-text"]/div/table[2]') %>%
  html_table()

censo_prov_sex <- censo_prov_sex[[1]]


#' Nombres de los titulos
colnames(censo_prov_sex) <- c("Provincia", "Varones", "Mujeres", "Masculinidad")

#' Limpiar datos
censo_prov_sex$Varones <- mgsub(".", "", censo_prov_sex$Varones)
censo_prov_sex$Mujeres <- mgsub(".", "", censo_prov_sex$Mujeres)
censo_prov_sex$Masculinidad <- mgsub(',', '.', censo_prov_sex$Masculinidad)

#' Transformar a numeros o caracteres
#' https://stackoverflow.com/questions/3418128/how-to-convert-a-factor-to-integer-numeric-without-loss-of-information

censo_prov_sex$Provincia <- as.character(censo_prov_sex$Provincia)
censo_prov_sex$Varones <- as.numeric(censo_prov_sex$Varones)
censo_prov_sex$Mujeres <- as.numeric(censo_prov_sex$Mujeres)
censo_prov_sex$Masculinidad <- as.numeric(censo_prov_sex$Masculinidad)

#' Eliminar la ultima fila de totales
censo_prov_sex <- censo_prov_sex[1:24,]

#' Añadimos una columnas con la suma de hombre y mujeres
censo_prov_sex <- cbind(censo_prov_sex, censo_prov_sex$Varones + censo_prov_sex$Mujeres)

#' ## Añadir datos elecciones_presidenciales_2015
censo_prov_sex_elecc15 <- cbind(censo_prov_sex, c("Cambiemos", "PJ", "PJ", "PJ", "Cambiemos", 
              "Cambiemos", "PJ", "PJ", "PJ", "Cambiemos","PJ","PJ",
              "Cambiemos", "Otros", "Otros", "Otros", "PJ", "PJ", "PJ",
              "PJ", "Otros", "Otros", "PJ", "PJ"))
colnames(censo_prov_sex_elecc15) <- c("Provincia", "Varones", "Mujeres", "Masculinidad", "Total","Elecciones_2015")

#' Guardar datos como .csv
write.csv(censo_prov_sex_elecc15, paste0(DATOS, "10_censo_provincia_sexo_elecc15_argentina.csv"))

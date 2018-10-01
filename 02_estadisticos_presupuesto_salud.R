#' ---
#' title: "ODH - Salud - Estadisticos"
#' author: "Noelia y Pablo"
#' date: "`r format(Sys.Date())`"
#' output: github_document
#' ---
#' Comparar la evolución del prespuesto con la inflacion 2015-2017.

#' ## LIBRERIAS
suppressPackageStartupMessages(library(dplyr))
library(magrittr)
library(ggplot2)
# library(broom)
# library(extrafont)

#' ## DIRECTORIOS
CENSOS <- "datos_censos/"
FIGURAS <- "figuras/"


#' ## FICHEROS ENTRADA
inflacion <- read.csv(paste0(CENSOS, "10_inflacion_anual_argentina.csv"))



#' ## CALCULOS
#' 
#' **1. Cargamos a manos los datos de presupuesto**
#' Informe  ....

presupuesto <- data.frame("x1" = seq(2015,2017,1),
                          "x2" = c(1111836711, 1306562490, 3460070241),
                          "x3" = c(1194580688, 2129330012, 2522989375),
                          "x4" = c(1126041761.51, 1531010762, 2123601704.80))

colnames(presupuesto) <- c("Año", "Cred. Inicial", "Cred. Vigente", "Devengado")

#' **2. Unimos las dos tablas**
#' 
#' 
df <- merge(presupuesto,inflacion,by = "Año")

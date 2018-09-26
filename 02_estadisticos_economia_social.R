#' ---
#' title: "ODH - Economia Social - Estadisticos"
#' author: "Noelia y Pablo"
#' date: "`r format(Sys.Date())`"
#' output: github_document
#' ---
#' ## IDEAS
#' AT = Argentina Trabaja
#' EH = Ellas Hacen
#' 
#' 1. Analisis de la diferencia por provincia num de titulares normalizado
#' por la población.
#' 
#' ## TAREAS:
#' 1. Asignar a cada provincia en la tabla2 a quien voto en 2015 (censo).
#' 2. Normalizar los programas (tabla2) con el censo por provincia.
#' 
#' ## LIBRERIAS
suppressPackageStartupMessages(library(dplyr))
library(magrittr)
library(ggplot2)
library(broom)
library(extrafont)

#' ## DIRECTORIOS
DATOS <- "/home/noelia/MEGAsync/ODH/datos_economia_social/"
CENSOS <- "/home/noelia/MEGAsync/ODH/datos_censos/"
FIGURAS <- "/home/noelia/MEGAsync/ODH/figuras/"

#' ## FICHEROS ENTRADA
tabla2 <- read.csv(paste0(DATOS, "10_economia_social_tabla2.csv"))
presupuesto <-  read.csv(paste0(DATOS, "10_economia_social_tabla3.csv"))
censo <- read.csv(paste0(CENSOS, "10_censo_provincia_sexo_elecc15_argentina.csv"))

censo[5] <- "Capital_Federal"

#' Los periodos son una categoria
tabla2$Periodo <- as.character(tabla2$Periodo)

#' ## PRUEBAS
#' http://stat545.com/block023_dplyr-do.html

#' **Ver info**
tabla2 %>%
  tbl_df() %>%
  glimpse()

censo %>%
  tbl_df() %>%
  glimpse()

#' ## Elegir las bases de datoS "EH"
ellas_hacen <- tabla2 %>%
  filter(Programa == "EH") %>% 
  group_by(Provincia) %>%
  arrange(Provincia)

#' https://www.r-graph-gallery.com/48-grouped-barplot-with-ggplot2/
#' http://felixfan.github.io/ggplot2-remove-grid-background-margin/
#' 
# Stacked Percent
geh <- ggplot(ellas_hacen, aes(fill=Periodo, y=Titulares, x=Provincia)) + 
  geom_bar( stat="identity", position="fill")
geh <- geh + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
               panel.background = element_blank(), axis.line = element_line(colour = "black"),
          axis.text.x = element_text(angle = 90, hjust = 1))
print(geh + ggtitle("Programa 'Ellas Hacen' 2015-2017"))

#'ggsave(paste0(FIGURAS, "economia_social_fig1.png"), geh)


#' ## Elegir las bases de datoS "AT"

argentina_trabaja <- tabla2 %>%
  filter(Programa == "AT") %>% 
  group_by(Provincia) %>%
  arrange(Provincia)

#' https://www.r-graph-gallery.com/48-grouped-barplot-with-ggplot2/
#' http://felixfan.github.io/ggplot2-remove-grid-background-margin/
#' 
# Stacked Percent
gat <- ggplot(argentina_trabaja, aes(fill=Periodo, y=Titulares, x=Provincia)) + 
  geom_bar( stat="identity", position="fill")
gat <- gat + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                   panel.background = element_blank(), axis.line = element_line(colour = "black"),
                   axis.text.x = element_text(angle = 90, hjust = 1))
print(gat + ggtitle("Programa 'Argentina Trabaja' 2015-2017"))

ggsave(paste0(FIGURAS, "economia_social_fig2.png"), gat)

#' ## Normalizar con respecto a los 

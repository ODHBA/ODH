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
library(tidyr)
library(dplyr)
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

#' **3.Normalizar valores**
#' La inflacion el primer año se toma como 100 y cada año ya respresenta lo que varia
#' respecto al anterior, para ver la evoluacion del 3 año se acumula.
#' 
#' Los presupuestos se calculan respecto al año anterior

#' reemplazo primero el valor de Inflación INDEC por Inflación ambito en 2015

df$X..IPC_INDEC[1] <- df$X..IPC_Ambito[1]
df$X <- NULL
df$`Cred. Inicial N.` <- cumsum(c(100,(diff(df$`Cred. Inicial`)[1]/df$`Cred. Inicial`[1])*100,
                           (diff(df$`Cred. Inicial`)[2]/df$`Cred. Inicial`[2])*100))
df$`Cred. Vigente N.` <- cumsum(c(100,(diff(df$`Cred. Vigente`)[1]/df$`Cred. Vigente`[1])*100,
                           (diff(df$`Cred. Vigente`)[2]/df$`Cred. Vigente`[2])*100))
df$`Devengado N.` <- cumsum(c(100,(diff(df$Devengado)[1]/df$Devengado[1])*100,
                           (diff(df$Devengado)[2]/df$Devengado[2])*100))
df$Inflacion <- cumsum(c(100,df$X..IPC_INDEC[2],df$X..IPC_INDEC[3]))
df$Año <- round(df$Año,digits = 0)
df2 <- df %>% select(Año,`Cred. Inicial N.`,`Cred. Vigente N.`,`Devengado N.`,Inflacion) %>%
  gather(key = "variable",value = "value",-Año) 

#' 

#' ## GRAFICO
p1 <- ggplot(df2,aes(x=Año,y=value)) + 
  geom_line(aes(color=variable)) +
  scale_color_manual(values = c("#00AFBB", "#E7B800","red","#000000"), name="Presupuesto") + 
  ylab(label="%") +
  scale_x_continuous(breaks=c(2015, 2016, 2017))  + theme_bw()

ggsave(paste0(FIGURAS,"presupuesto_salud_inflacion_bw.png"),p1,dpi = 600)
  
p1
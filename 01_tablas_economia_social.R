#' ---
#' title: "ODH - Economia Social"
#' author: "Noelia y Pablo"
#' date: "`r format(Sys.Date())`"
#' output: github_document
#' ---
#' 
#' ## LINKS AYUDA
#' https://ropensci.org/blog/2016/11/16/tesseract/
#' 
#' ## LIBRERIAS
library(tidyverse)
library(pdftools)
library(stringr)
library(tesseract)
library(qdap)
#'
#' ## DIRECTORIOS
DATOS <- "/home/noelia/MEGAsync/ODH/datos_economia_social/"

 
#' ## FICHEROS ENTRANTES. Escanear el documento.
#' El problema que tienen algunos ficheros es que no son PDF, sino copias
#' escaneadas y guardadas en PDF, lo que hace que se tenga que usar herramientas
#' extra que sea capaces de reconocer texto (OCR)
#'
#' Solo lo hacemos una vez. Separa el documento (ejemplo.pdf) en .png con el numero de pagina al final
#' (ejemplo4.png). Recomendación: especificar la carpetas donde van a
#' 

#' ## Abrir los ficheros

#' La tabla 1 es un resumen de la tabla 2, asi que la quito, porque 
#' ademas no tiene en cuenta todas las provincias.

# tabla1_ori <- ocr(paste0(DATOS, "economia_social_4.png")) %>%
#   readr::read_lines()

#' Otra forma de cargar las tablas de los _pdfs_ es por medio del 
#' paquete *tabulizer*. Ver ejemplos en 
#' https://ropensci.org/tutorials/tabulizer_tutorial/
#' 
#' Abrir las paginas 5 a 8 (incluidos) = Tabla 2
paginas <- seq(5,8,1)

for(i in 1:length(paginas)){
  eval(parse(text=paste0("tabla2_ori", paginas[i], " <- ocr('", DATOS, "economia_social_", paginas[i], ".png') %>% readr::read_lines()")))
  
}

tabla2_ori <- c(tabla2_ori5, tabla2_ori6, tabla2_ori7, tabla2_ori8)

#' La tabla 3 la hago a mano.
#' Esta en la tabla de la pagina 10
fila1 <- c(2015, "AT", 4692.24, 3501.63)
fila2 <- c(2015, "EH", 3539.76, 2641.58)
fila3 <- c(2016, "AT", 7064.40, 5957.66)
fila4 <- c(2016, "EH", 3973.72, 3351.18)
fila5 <- c(2017, "AT", 10419.39, 9979.78)
fila6 <- c(2017, "EH", 4681.18, 4483.67)

tabla3_ori <- rbind(fila1,fila2,fila3, fila4,fila5, fila6)
df3 <- as.data.frame(tabla3_ori)
colnames(df3) <- c("Año", "Programa", "Presupuesto_asignado", "Presupuesto_ejecutado")
rownames(df3) <- NULL

#' ## Transformando a DATA.FRAME la tabla 2

#' **1. Reemplazar los nombres de las ciudades que esten separados por " "**
#' Para ellos cremos dos vectores "original" y "reemplazo"
original <- c("BUENOS AIRES", "BUENQOS AIRES", "CAPITAL FEDERAL", "ENTRE RIOS", "LA RIOJA",
              "RIO NEGRO", "SAN JUAN", "SAN LUIS", "SANTA FE", "SANTIAGO DEL ESTERO",
              "TIERRA DEL FUEGO", "Total general")
reemplazo <- c("BUENOS_AIRES", "BUENOS_AIRES", "CAPITAL_FEDERAL", "ENTRE_RIOS", "LA_RIOJA",
               "RIO_NEGRO", "SAN_JUAN", "SAN_LUIS", "SANTA_FE", "SANTIAGO_DEL_ESTERO",
               "TIERRA_DEL_FUEGO", "Total_General")

ori_signos <- c(".", "'", "1F", "$12F", "3F")
ree_signos <- c(" ", " ", "1 F", "12 F", "3 F")

tabla2_new <- mgsub(original, reemplazo, tabla2_ori)
tabla2_new <- mgsub(ori_signos, ree_signos, tabla2_new)

#' ** 2. Separar las palabras como elementos de una lista**

#' En la tabla 1 no tenemos en cuenta las primeras filas.
tabla2_new <- strsplit(tabla2_new[2:247], " ")

#' Eliminar los elementos de la lista que esten vacios
tabla2_new <- tabla2_new[lapply(tabla2_new,length)>0]

#' Eliminar otros elementos:
#tabla2_new[[92]] <- tabla2_new[[92]][-1]

#' ** 3. Rellenar datos NA**
#' Solo la tabla1, en la tabla 2 no hay datos faltantes.

#' Ver la longitud max:
# longitud <- array(0, dim=c(length(tabla1_new)))
# for(i in 1:length(tabla1_new)){
#   longitud[i] <- length(tabla1_new[[i]])
# }
# 
# longitud_max <- max(longitud)

#' **Rellenar con NA, donde no hay datos. Automatico**
#' Esta sería la forma autmatica, suponiendo que los valores NA
#' estan al final de los listas. 
#' Rellenar con NA aquellos que tiene longitud < longitud_max: 

# for(i in 1:length(tabla1_new)){
#   if(length(tabla1_new[[i]]) < longitud_max){
#     tabla1_new[[i]] <- c(tabla1_new[[i]], rep("NA", longitud_max-longitud[i]))
#   }
# }

#' Comprobar que todos tienen las misma longitud

# longitud_new <- array(0, dim=c(length(tabla1_new)))
# for(i in 1:length(tabla1_new)){
#   longitud_new[i] <- length(tabla1_new[[i]])
# }

#' Sin embargo no es asi, y habria que ir consultando el pdf
#' para saber donde hay que ubicar los NA.
# tabla1_new[[5]] <- c(tabla1_new[[5]][1], "NA", tabla1_new[[5]][2:3], rep("NA", 3))
# tabla1_new[[9]] <- c(tabla1_new[[9]][1], "NA", tabla1_new[[9]][2:5], rep("NA", 1))
# tabla1_new[[13]] <- c(tabla1_new[[13]][1], "NA", tabla1_new[[13]][2:3], rep("NA", 3))
# tabla1_new[[14]] <- c(tabla1_new[[14]], rep("NA", 2))
# tabla1_new[[18]] <- c(tabla1_new[[18]][1], "NA", tabla1_new[[18]][2:3], rep("NA", 3))
# tabla1_new[[20]] <- c(tabla1_new[[20]][1], rep("NA",5), tabla1_new[[20]][2])

tabla2_new[[92]] <- c(tabla2_new[[92]][2:6])

#' d. Transformar a data.frame
#df1 <- data.frame(matrix(unlist(tabla1_new), nrow=length(tabla1_new), byrow=T))
df2 <- data.frame(matrix(unlist(tabla2_new), nrow=length(tabla2_new), byrow=T))

#' e. Poner titulos
# colnames(df1) <- c("Provincia", 
#                    "AT_2015", "AT_2016", "AT_2017", 
#                    "EH_2015", "EH_2016", "EH_2017")
colnames(df2) <- c("Programa", "Periodo", "Titulares", "Sexo", "Provincia")

#' Transformar de factores a numeros o caracteres
#' https://stackoverflow.com/questions/3418128/how-to-convert-a-factor-to-integer-numeric-without-loss-of-information
df2$Programa <- as.character(df2$Programa)
df2$Periodo <- as.numeric(levels(df2$Periodo))[df2$Periodo]
df2$Titulares <- as.numeric(levels(df2$Titulares))[df2$Titulares]
df2$Sexo <- as.character(df2$Sexo)
df2$Provincia <- as.character(df2$Provincia)


#' **Relleno de provincias faltantes**
#' Por programa, año y sexo.
df2 <- rbind(df2, c("AT", "201512", 0, "M", "CAPITAL_FEDERAL"), 
             c("AT", "201512", 0, "M", "CAPITAL_FEDERAL"), 
             c("AT", "201512", 0, "M", "CHUBUT"),
             c("AT", "201512", 0, "F", "CHUBUT"), 
             c("AT", "201612", 0, "M", "CHUBUT"), 
             c("AT", "201612", 0, "F", "CHUBUT"), 
             c("AT", "201712", 0, "M", "CHUBUT"), 
             c("AT", "201712", 0, "F", "CHUBUT"), 
             c("EH", "201512", 0, "F", "CHUBUT"), 
             c("EH", "201612", 0, "F", "CHUBUT"), 
             c("EH", "201712", 0, "F", "CHUBUT"), 
             c("AT", "201512", 0, "M", "CORDOBA"),
             c("AT", "201512", 0, "F", "CORDOBA"),
             c("EH", "201512", 0, "F", "CORDOBA"),
             c("EH", "201612", 0, "F", "CORDOBA"),
             c("EH", "201712", 0, "F", "CORDOBA"),
             c("AT", "201512", 0, "M", "JUJUY"),
             c("AT", "201512", 0, "F", "JUJUY"),
             c("EH", "201712", 0, "F", "JUJUY"),
             c("AT", "201512", 0, "M", "LA_PAMPA"),
             c("AT", "201512", 0, "F", "LA_PAMPA"),
             c("AT", "201612", 0, "M", "LA_PAMPA"),
             c("AT", "201612", 0, "F", "LA_PAMPA"),
             c("AT", "201712", 0, "M", "LA_PAMPA"), 
             c("AT", "201712", 0, "F", "LA_PAMPA"),
             c("EH", "201512", 0, "F", "LA_PAMPA"),
             c("EH", "201612", 0, "F", "LA_PAMPA"),
             c("EH", "201712", 0, "F", "LA_PAMPA"), 
             c("AT", "201512", 0, "M", "NEUQUEN"), 
             c("AT", "201512", 0, "F", "NEUQUEN"),
             c("EH", "201512", 0, "F", "NEUQUEN"), 
             c("EH", "201612", 0, "F", "NEUQUEN"), 
             c("EH", "201712", 0, "F", "NEUQUEN"),
             c("AT", "201512", 0, "M", "SANTA_CRUZ"),
             c("AT", "201512", 0, "F", "SANTA_CRUZ"),
             c("AT", "201612", 0, "M", "SANTA_CRUZ"),
             c("AT", "201612", 0, "F", "SANTA_CRUZ"),
             c("AT", "201712", 0, "M", "SANTA_CRUZ"),
             c("AT", "201712", 0, "F", "SANTA_CRUZ"),
             c("EH", "201512", 0, "F", "SANTA_CRUZ"),
             c("EH", "201612", 0, "F", "SANTA_CRUZ"),
             c("EH", "201712", 0, "F", "SANTA_CRUZ"),
             c("AT", "201512", 0, "M", "SANTA_FE"),
             c("AT", "201512", 0, "F", "SANTA_FE"),
             c("EH", "201512", 0, "F", "SANTA_FE"),
             c("EH", "201612", 0, "F", "SANTA_FE"),
             c("EH", "201712", 0, "F", "SANTA_FE"),
             c("AT", "201512", 0, "M", "TIERRA_DEL_FUEGO"), 
             c("AT", "201512", 0, "F", "TIERRA_DEL_FUEGO"),
             c("AT", "201612", 0, "M", "TIERRA_DEL_FUEGO"), 
             c("AT", "201612", 0, "F", "TIERRA_DEL_FUEGO"),
             c("AT", "201712", 0, "M", "TIERRA_DEL_FUEGO"),
             c("AT", "201712", 0, "F", "TIERRA_DEL_FUEGO"),
             c("EH", "201512", 0, "F", "TIERRA_DEL_FUEGO"),
             c("EH", "201612", 0, "F", "TIERRA_DEL_FUEGO"))

tabla2 <- df2
tabla3 <- df3

#' ## Guardar Tablas como .csv
write.csv(tabla2,paste0(DATOS, "10_economia_social_tabla2.csv"))
write.csv(tabla3,paste0(DATOS, "10_economia_social_tabla3.csv"))



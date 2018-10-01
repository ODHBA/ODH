#' ---
#' title: "ODH - ESI"
#' author: "Noelia y Pablo"
#' date: "`r format(Sys.Date())`"
#' output: github_document
#' ---
#' 
#' Vamos a la tasa de inflacion (%) de la wikipedia a mano desde el año 2008-2017
#' https://es.wikipedia.org/wiki/Anexo:Evolución_del_Índice_de_Precios_al_Consumidor_en_Argentina
#' 

#'## DIRECTORIOS
DATOS <- "datos_censos/"

inflacion <- data.frame("x1" = seq(2008,2017,1),
                        "x2" = c(7.2, 7.7,10.9, 9.5, 10.8, 10.9, 23.9, NA, 36.2, 24.8),
                        "x3" = c(23.8, 16.4, 25.9, 22.89, 25.69, 28.38, 38.53, 27.59, 40.39, 24.69), 
                        "x4" = c(rep("CFK", 8), rep("MM", 2)))

colnames(inflacion) <- c("Año", "% IPC_INDEC", "% IPC_Ambito", "Presidente")

View(inflacion)

write.csv(inversion_esi, paste0(DATOS, "10_inflacion_anual_argentina.csv"))

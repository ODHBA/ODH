#' ---
#' title: "ODH - ESI"
#' author: "Noelia y Pablo"
#' date: "`r format(Sys.Date())`"
#' output: github_document
#' ---
#' 
#' Vamos a copiar a mano las tablas del informe (24.11.2017) sobre el 
#' Programa Nacional de Educación Sexual integrada.
#' 

#'## DIRECTORIOS
DATOS <- "datos_esi/"

#' ## Tabla capacitacion docente 1 (pag. 4)
#' 

cap_docente_cursos <- data.frame("Año" = seq(2009,2017,1),
                             "Cantidad de Cursos" = c(1,1,1,2,2,2,6,4,2),
                             "Cantidad de Inscriptos" = c(1560, 1371,3025,2668,3332, 3943,16914,6720,4450))

colnames(cap_docente_cursos) <- c("Año", "Cantidad de Cursos", "Cantidad de Inscriptos")

write.csv(cap_docente_cursos, paste0(DATOS, "10_esi_capacitacion_docente_cursos.csv"))

#' ## Tabla capacitacion docente (pag 5)
#' 
cap_docente_cantidad <- data.frame("Periodo" = c("2008-2011", seq(2012,2017,1)),
                              "Cantidad escuelas" = c(NA,6000,10000,14000,14000,100,500),
                              "Cantidad docentes" = c(52200,12000,20000,28000,55000,200,1050))

colnames(cap_docente_cantidad) <- c("Periodo", "Cantidad escuelas", "docentes")

write.csv(cap_docente_cantidad,paste0(DATOS, "10_esi_capacitacion_docente_cantidad.csv"))    

#' ## Tabla inversión (pag 7)
#' 

inversion_esi <- data.frame("Año" = seq(2009,2017,1),
                            "Resolución_$" = c(0,0,0,312000, 790000, 1400000,1250000,0,0),
                            "x1" = c(0,178000,442000,4000000,12324720,23601066,36679471,0,31000000),
                            "x2" = c(300000,363000,450120,544645,675359,865472,5300000,2024776,4211136),
                            "x3" = c(0,0,0,0,0,0,9246580,0,0),
                            "x4" = c(0,0,5480000,264000,0,4447000,3080000,0,0),
                            "x5" = c(0,0,713936,1837855,0,48000,199687,0,0),
                            "x6" = c(0,0,0,0,0,124200,0,0,0),
                            "x7" = c(0,0,0,0,0,326130,0,0,0),
                            "x8" = c(0,0,0,0,0,0,0,20210669,0),
                            "x9" = c(0,0,0,0,0,0,0,5427178,0),
                            "x10" =c(0,0,0,0,0,0,0,0,800000))
colnames(inversion_esi) <- c("Año", "Resolución", "Capacitación presencial", "Capacitación virtual", 
                             "Producción materiales", "Distribución materiales", "Producción 'canal ENCUENTRO' y 'PAKA-PAKA'",
                             "Producción cortos UNFPA", "Evaluación y monitoreo", "Encuentros de capacitación", 
                             "Encuentros sobre violencia contra las mujeres", "Plan Nac. disminución del embarazo")   
                             

write.csv(inversion_esi, paste0(DATOS, "10_esi_inversion.csv"))
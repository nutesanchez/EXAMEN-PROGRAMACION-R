
# =============================================
# Función estimar_calorias()
# =============================================
# Esta función estima el requerimiento calórico basal en adultos
# a partir de las variables: masa grasa (kg), masa muscular (kg),
# estatura (cm), edad (años), sexo (0 = mujer, 1 = hombre),
# y nivel de actividad física (sedentario, moderado, vigoroso).
# El cálculo se basa en un modelo de regresión interno generado
# con un dataset real (InBodyExcelData_catedra_R.xlsx).

estimar_calorias <- function(grasa, musculo, estatura, edad, sexo, actividad) {

  # Validaciones básicas
  if (any(is.na(c(grasa, musculo, estatura, edad, sexo, actividad)))) {
    stop("Todos los argumentos deben estar completos.")
  }

  if (!actividad %in% c("sedentario", "moderado", "vigoroso")) {
    stop("El nivel de actividad debe ser 'sedentario', 'moderado' o 'vigoroso'.")
  }

  # Predicción basada en el modelo de regresión lineal ajustado
  rcb <- -730.45 +
         305.28 * sexo +
         (-3.34) * grasa +
         26.37 * musculo +
         13.64 * estatura +
         (-5.49) * edad

  # Ajuste por nivel de actividad física usando coeficientes clínicos
  coef_act <- dplyr::case_when(
    actividad == "sedentario" ~ 1.2,
    actividad == "moderado" ~ 1.5,
    actividad == "vigoroso" ~ 1.75
  )

  # Calorías totales estimadas
  calorias_totales <- rcb * coef_act

  # Clasificación según requerimiento estimado
  clasificacion <- dplyr::case_when(
    calorias_totales < 1500 ~ "Muy bajo",
    calorias_totales < 1800 ~ "Bajo",
    calorias_totales < 2200 ~ "Moderado",
    TRUE ~ "Alto"
  )

  # Retorno del resultado como lista con clase S3
  resultado <- list(
    rcb = round(rcb, 1),
    total = round(calorias_totales, 1),
    clasificacion = clasificacion
  )
  class(resultado) <- "estimacion_calorica"
  return(resultado)
}

# =============================================
# Método print para clase estimacion_calorica
# =============================================
print.estimacion_calorica <- function(x, ...) {
  cat("=== Estimación del Requerimiento Calórico ===\n")
  cat("Calorías basales estimadas : ", x$rcb, "kcal\n")
  cat("Calorías totales ajustadas : ", x$total, "kcal\n")
  cat("Clasificación energética   : ", x$clasificacion, "\n")
  invisible(x)
}

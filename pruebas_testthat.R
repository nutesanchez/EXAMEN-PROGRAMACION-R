
# Archivo de pruebas para estimar_calorias()
# Evaluación Magíster en Data Science UDLA 2025

library(testthat)

# 1. Prueba básica de funcionamiento
test_that("La función retorna objeto de clase estimacion_calorica y valores válidos", {
  resultado <- estimar_calorias(grasa = 24, musculo = 26, estatura = 165, edad = 35, sexo = 0, actividad = "moderado")
  expect_s3_class(resultado, "estimacion_calorica")
  expect_true(resultado$rcb > 0)
  expect_true(resultado$total > 0)
  expect_true(resultado$clasificacion %in% c("Muy bajo", "Bajo", "Moderado", "Alto"))
})

# 2. Prueba de errores con datos faltantes
test_that("Se genera error si hay datos faltantes", {
  expect_error(estimar_calorias(NA, 26, 165, 35, 0, "moderado"))
  expect_error(estimar_calorias(24, 26, NA, 35, 0, "moderado"))
})

# 3. Prueba de errores por actividad inválida
test_that("Se genera error si actividad no es reconocida", {
  expect_error(estimar_calorias(24, 26, 165, 35, 0, "superactivo"))
})

# 4. Prueba de validación del sexo
test_that("Sexo debe ser 0 o 1", {
  expect_error(estimar_calorias(24, 26, 165, 35, 2, "moderado"))
})

# 5. Prueba de validación clínica para estatura y edad
test_that("Valores clínicamente fuera de rango producen error", {
  expect_error(estimar_calorias(24, 26, 90, 35, 0, "moderado"))  # estatura muy baja
  expect_error(estimar_calorias(24, 26, 165, 5, 0, "moderado"))  # edad muy baja
})

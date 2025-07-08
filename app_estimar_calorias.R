library(shiny)
library(readxl)
library(dplyr)
library(purrr)

# -------------------- FUNCIÓN AUXILIAR --------------------
estimar_smm_lee <- function(edad, sexo, estatura, circ_brazo, circ_pantorrilla) {
  if (any(is.na(c(edad, sexo, estatura, circ_brazo, circ_pantorrilla)))) {
    stop("Todos los argumentos deben estar completos.")
  }
  smm <- 0.244 * estatura + 7.8 * circ_brazo + 6.6 * circ_pantorrilla - 0.098 * edad + 0.4 * sexo - 10.1
  return(smm)
}

# -------------------- FUNCIÓN PRINCIPAL --------------------
estimar_calorias <- function(grasa, musculo, estatura, edad, sexo, actividad) {
  if (any(is.na(c(grasa, musculo, estatura, edad, sexo, actividad)))) {
    stop("Todos los parámetros deben estar completos.")
  }
  if (!actividad %in% c("sedentario", "moderado", "vigoroso")) {
    stop("El nivel de actividad debe ser: sedentario, moderado o vigoroso.")
  }
  if (!sexo %in% c(0, 1)) {
    stop("El sexo debe ser 0 (mujer) o 1 (hombre).")
  }

  beta_0 <- 500
  beta_grasa <- 5.2
  beta_musculo <- 20.5
  beta_estatura <- 3.5
  beta_edad <- -2.8
  beta_sexo <- 70

  rcb <- beta_0 +
         beta_grasa * grasa +
         beta_musculo * musculo +
         beta_estatura * estatura +
         beta_edad * edad +
         beta_sexo * sexo

  coef_actividad <- case_when(
    actividad == "sedentario" ~ 1.2,
    actividad == "moderado" ~ 1.5,
    actividad == "vigoroso" ~ 1.75
  )

  total <- round(rcb * coef_actividad, 1)

  clasificacion <- case_when(
    total < 1600 ~ "Muy bajo",
    total >= 1600 & total < 2100 ~ "Bajo",
    total >= 2100 & total < 2600 ~ "Moderado",
    total >= 2600 ~ "Alto"
  )

  resultado <- list(rcb = rcb, total = total, clasificacion = clasificacion)
  class(resultado) <- "estimacion_calorica"
  return(resultado)
}

# -------------------- UI --------------------
ui <- fluidPage(
  tags$head(
    tags$style(HTML("
      body {
        background-color: #f3f9f3;
        font-family: Arial;
      }
      h1, h2, h3 {
        color: #2e7d32;
      }
      .well {
        background-color: #e8f5e9;
        border-color: #c8e6c9;
      }
      .btn {
        background-color: #66bb6a;
        color: white;
      }
    "))
    
  ),
  titlePanel("Estimador de Requerimiento Calórico - Nutrición Clínica"),
  
  wellPanel(
    h4("Fórmula utilizada:"),
    HTML("RCB = 500 + 5.2·grasa + 20.5·musculo + 3.5·estatura - 2.8·edad + 70·sexo <br>
       Total = RCB × coef_actividad <br>
       coef_actividad = 1.2 (sedentario), 1.5 (moderado), 1.75 (vigoroso)")
  ),
  
  tags$div(
    style = "padding: 10px 15px; background-color: #f1f8e9; border-left: 5px solid #66bb6a; margin-bottom: 20px;",
    tags$p(
      style = "margin: 0; font-style: italic; color: #2e7d32;",
      "Esta app utiliza el modelo presentado en el informe académico, basado en parámetros antropométricos y factores de actividad física."
    )
  ),
  

  sidebarLayout(
    sidebarPanel(
      h4("Cálculo individual"),
      numericInput("grasa", "Masa grasa (kg):", value = 20, min = 0),
      numericInput("musculo", "Masa muscular (kg):", value = 25, min = 0),
      numericInput("estatura", "Estatura (cm):", value = 165, min = 100, max = 250),
      numericInput("edad", "Edad (años):", value = 30, min = 10, max = 120),
      selectInput("sexo", "Sexo:", choices = c("Mujer" = 0, "Hombre" = 1)),
      selectInput("actividad", "Nivel de actividad:", choices = c("sedentario", "moderado", "vigoroso")),
      actionButton("calcular", "Estimar Calorías"),
      hr(),
      h4("Cálculo por lote desde Excel"),
      fileInput("archivo", "Subir archivo Excel (.xlsx)", accept = ".xlsx"),
      actionButton("procesar", "Aplicar a todos los registros")
    ),

    mainPanel(
      h4("Resultado individual:"),
      verbatimTextOutput("resultado_ind"),
      hr(),
      h4("Resultados por lote:"),
      tableOutput("tabla_resultados")
    )
  )
)

# -------------------- SERVER --------------------
server <- function(input, output) {

  resultado <- eventReactive(input$calcular, {
    tryCatch({
      r <- estimar_calorias(
        grasa = input$grasa,
        musculo = input$musculo,
        estatura = input$estatura,
        edad = input$edad,
        sexo = as.numeric(input$sexo),
        actividad = input$actividad
      )
      return(r)
    }, error = function(e) {
      return(paste("Error:", e$message))
    })
  })

  output$resultado_ind <- renderPrint({ resultado() })

  output$tabla_resultados <- renderTable({
    req(input$archivo)
    if (input$procesar == 0) return(NULL)

    datos <- read_excel(input$archivo$datapath)
    names(datos) <- tolower(gsub(" ", "_", names(datos)))

    if (!all(c("grasa", "musculo", "estatura", "edad", "sexo", "actividad") %in% names(datos))) {
      return(data.frame(Error = "El archivo debe contener las columnas: grasa, musculo, estatura, edad, sexo, actividad"))
    }

    tryCatch({
      datos <- datos %>%
        mutate(
          sexo = as.numeric(sexo),
          actividad = tolower(trimws(actividad)),
          resultado = purrr::pmap(list(grasa, musculo, estatura, edad, sexo, actividad),
                                  ~ estimar_calorias(..1, ..2, ..3, ..4, ..5, ..6))
        ) %>%
        rowwise() %>%
        mutate(
          rcb = resultado$rcb,
          total = resultado$total,
          clasificacion = resultado$clasificacion
        ) %>%
        select(-resultado)
      return(datos)
    }, error = function(e) {
      return(data.frame(Error = e$message))
    })
  })
}

# -------------------- RUN APP --------------------
shinyApp(ui = ui, server = server)

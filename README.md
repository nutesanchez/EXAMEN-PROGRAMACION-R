# EXAMEN PROGRAMACION R: Función de Estimación de Requerimiento Calórico Basal

Este proyecto fue desarrollado para el examen de Programación en R del Magíster en Data Science (UDLA, 2025). Su finalidad es estimar el requerimiento energético basal (RCB) ajustado por composición corporal y nivel de actividad física, integrando funciones vectorizadas, programación modular y visualización interactiva con `shiny`.

---

## Objetivo

Desarrollar una herramienta reproducible en R para estimar el requerimiento calórico basal a partir de variables antropométricas (grasa, músculo, estatura, edad, sexo) y nivel de actividad física. Se buscó facilitar su uso clínico a través de una app interactiva, adaptable a datos individuales o por lote.

---

## Fundamento

El modelo utiliza una regresión lineal simulada basada en coeficientes propuestos, reflejando el aporte fisiológico de cada variable al gasto energético basal. El nivel de actividad se incorpora como un factor multiplicativo (1.2, 1.5, 1.75) según clasificación clínica.

La función principal `estimar_calorias()` fue construida bajo principios de programación robusta y reutilizable. Además, se generó una clase S3 (`pacientes_caloricos`) y una Shiny app para facilitar su adopción práctica.

---

## Estructura del proyecto

```
/proyecto_estimacion_calorica
│
├── EXAMEN_R_EVELYN_SANCHEZ_GITHUB.Rmd
│
├── /data
│   ├── InBodyExcelData_catedra_R.xlsx
│   └── datos_prueba_app_2.xlsx
│
├── /scripts
│   └── app_estimar_calorias.R
│
├── /www
│   └── preview_excel.png
│
└── README.md

```

---

## Componentes clave

- `EXAMEN_R_EVELYN_SANCHEZ_ENTREGA_ULTIMA.Rmd`: documento reproducible con desarrollo completo, funciones, pruebas, visualización y retroalimentación.
- `datos_prueba_app_2.xlsx`: archivo de muestra para probar la app en modo por lote.
- `app_estimar_calorias.R`: aplicación shiny que permite ingreso individual o carga desde Excel.
- `preview_excel.png`: imagen ilustrativa para uso explicativo en el informe.

---

## Ejecución de la app Shiny

```r
shiny::runApp("scripts/app_estimar_calorias.R")
```

---

## Requisitos del sistema

- R 4.2 o superior
- Paquetes R necesarios:
  - shiny
  - readxl
  - dplyr
  - purrr
  - knitr

Instalación:

```r
install.packages(c("shiny", "readxl", "dplyr", "purrr", "knitr"))
```

---

## Referencias

- Lee RC, Wang Z, Heo M, Ross R, Janssen I, Heymsfield SB. (2000). Total-body skeletal muscle mass: development and cross-validation of anthropometric prediction models. *Am J Clin Nutr*, 72(3):796–803.
- FAO/WHO/UNU. (2001). Human energy requirements. Report of a Joint Expert Consultation.
- Wickham, H. (2019). *Advanced R*. Chapman and Hall/CRC.
- Xie, Y. (2023). *R Markdown: The Definitive Guide*. Chapman and Hall/CRC.

---

## Video explicativo del proyecto (examen final)

Este video resume el desarrollo completo del proyecto, incluyendo:

- Objetivo general y contexto clínico
- Función `estimar_calorias()` y su lógica interna
- Clase S3 implementada (`pacientes_caloricos`)
- Aplicación Shiny: ingreso individual y por lote
- Revisión del informe `.Rmd` y estructura modular
- Vinculación con GitHub y reproducibilidad

🔗 [Ver grabación de examen final en Zoom](https://udla.zoom.us/rec/share/xmHrbghfnQWNcn7BBg35ExQgOe-_FUE_wuW5u_hxxh3wMXXqbDAIwIZCV3gCdjSU.I4iwGZDfTkxWk3gi?startTime=1752009560000&pwd=DJrZ3eMpATBA6RiAOQAAIAAAAJJ_32p3vCKpCGmt-cZYqR-Oegtwta1I3ibrtbGtMVXzqH9dyVD76fDGBEwe4_0suDAwMDAwMQ)

---

## Licencia

Este proyecto es de carácter académico. Para fines de reproducción docente o clínica, se sugiere citar a la autora.

---

Proyecto desarrollado por **Evelyn Sánchez**  
Magíster en Data Science – Universidad de Las Américas (UDLA), 2025

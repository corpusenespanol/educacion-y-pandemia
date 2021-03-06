
# Instalar paquetes -------------------------------------------------------

#install.packages("rvest")
#install.packages("purrr")
#install.packages("readr")
packageDescription("rvest") #si quieres saber más sobre estos paquetes puedes correr esta línea de código

# Habilitar paquetes ------------------------------------------------------

library(rvest)
library(purrr)
library(readr)

# Leer el html ------------------------------------------------------------

h <- read_html("index.html")


# Explorar la sección que interesa ----------------------------------------

h %>%
  html_nodes(xpath = '//*[@id="calibre_link-27"]') %>% 
  html_text()


# Crear una regla para extraer todas las secciones del tipo ---------------

art <- h %>% html_nodes(xpath="//div[starts-with(@id,'calibre_link-')][@class='calibre'][*//p[@class='autor']]") %>% 
  .[2:35]

# Extraer el texto de esas secciones --------------------------------------

art_map <- map(art, ~html_text(.x, trim = TRUE)) 

# Extraer los títulos de las secciones ------------------------------------

titulos <- h %>% html_nodes(xpath="//p[starts-with(@id,'calibre_link-') and @class='entrada']")

titulos <- map(titulos, html_text) %>% 
  .[3:36] %>% 
  unlist() %>% 
  janitor::make_clean_names() 


# Guardar un archivo de texto por cada capítulo extraído ------------------

dir.create("corpus")

ruta_archivos <- glue::glue("corpus/{titulos}.txt")

walk2(art3, ruta_archivos, readr::write_file)

library(rvest)
library(plotly)
library(dplyr)

# Web scraping with rvest
link <- "https://en.wikipedia.org/wiki/Template:COVID-19_pandemic_data"
covid <- read_html(link) %>%
  html_element("table") %>%
  html_table(dec = ".")
covid$Cases <- as.numeric(gsub(pattern = ",", replacement = "", covid$Cases))
covid$Deaths <- as.numeric(gsub(pattern = ",", replacement = "", covid$Deaths))
covid <- covid[, -1]
# Using Built-in Country and State Geometries
df <- read.csv("https://raw.githubusercontent.com/plotly/datasets/master/2014_world_gdp_with_codes.csv")
colnames(df) <- c("Location", "Val1", "Codes")
# inner join by location
df1 <- merge(x = covid, y = df, by = "Location")
# Plots
fig1 <- plot_ly(df1, type = "choropleth", locations = ~Codes, z = ~Cases, text = ~Location, color = ~Cases) %>%
  layout(title = "Number of Cases(Covid-19)")
fig2 <- plot_ly(df1, type = "choropleth", locations = ~Codes, z = ~Deaths, text = ~Location, color = ~Deaths) %>%
  layout(title = "Number of Deaths(Covid-19)")
# fig1;fig2
fig2

#attach packages
library(tidyverse)
library(shiny)
library(shinythemes)
library(here)

#read in spooky_data.csv
spooky <- read_csv(here::here("data", "spooky_data.csv"))

#create my user interface
ui <- fluidPage( #fluidPage adjusts page sizing for different devices
  theme = shinytheme("cyborg"),
  titlePanel("How much sugar is too much?"),
  sidebarLayout(
    sidebarPanel("My widgets are here",
                 selectInput(inputId = "state_select", #label wisely in complex functions!
                             label = "Pick a state, any state",
                             choices = unique(spooky$state) #print every unique state name
                             )
                 ),
    mainPanel("My outputs are here",
              tableOutput(outputId = "candy_table")
              )
  )
)

#create the server
server <- function(input, output) {

  state_candy <- reactive({
    spooky %>%
      filter(state == input$state_select) %>%  #state on dataframe must match state selected by user
      select(candy, pounds_candy_sold)
    })

  output$candy_table <- renderTable({  #because this is not a static output
    state_candy() #() because it's reactive
  })
}

#tell R this is a shiny app
shinyApp(ui=ui, server=server)

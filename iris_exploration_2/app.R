#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(dplyr)
library(DT)
library(shinythemes)
library(purrr)

ui <- navbarPage("Iris exploration app", #New feature 1: changed fluidPage to navbarPage to improve user experience
                 theme = shinytheme("united"), #New feature 2: changed the theme
                 
                 tabPanel("About", #New feature number 3: added an "About" panel to introduce the app
                          tags$h1("Welcome to the Iris Exploration App"),
                          tags$hr(),
                          p("Welcome to my iris exploration shiny app! This is part of the 
                                    Assignment 4 of the STAT545B course at the University of British Columbia."),
                          p("For this assignment, I decided to improve my previously developed shiny app 
                                    (Assignment Option C). Its goal is to provide a dynamic exploration of the variables
                                    in the iris dataset, which is built-in in R. Briefly, and according to its R 
                                    documentation, 'This famous (Fisher's or Anderson's) iris data set gives the 
                                    measurements in centimeters of the variables sepal length and width and petal 
                                    length and width, respectively, for 50 flowers from each of 3 species of iris. 
                                    The species are Iris setosa, versicolor, and virginica.'"),
                          p("In this app, the following tabs are available:"),
                          tags$ul(
                            tags$li("About: Here you can find information about the app."),
                            tags$li("Data Exploration: Here you can explore the relationship between 
                                    the different variables in the iris dataset, plot them, and download the data or 
                                    plot that you selected."),
                            tags$li("Summary: Here you can find the summary of each variable grouped by species.")
                          ),
                          p("Happy data exploration!"),
                          img(src = "iris.png", height = 320, width = 800),br(), #New feature #4: adding an image
                          tags$i("Petals and sepals for Iris setosa, versicolor and virginica. Obtained from https://towardsdatascience.com/the-iris-dataset-a-little-bit-of-history-and-biology-fb4812f5a7b5. "),
                          br(),br(),
                          tags$i("This app was developed by Erick I. Navarro Delgado")
                          ),
                
                 tabPanel("Data Exploration",
                          sidebarLayout(
                            tabsetPanel(
                              sidebarPanel(
                                checkboxGroupInput("selected_species",
                                                   "Species:",
                                                   unique(iris$Species),
                                                   selected = iris$Species), #Included feedback from Assignment 3
                                selectInput("x_axis", 
                                            "X axis", 
                                            names(select(iris, -Species)),
                                            selected = "Sepal.Length"), 
                                selectInput("y_axis", 
                                            "Y axis",
                                            names(select(iris, -Species)),
                                            selected = "Sepal.Width"),
                                
                                downloadButton("downloadPlot", label = "Download plot"), #New feature 5: download the plot that the user produced
                                br(), br(),
                                downloadButton("downloadData", label = "Download data") #New feature 6: download the data that the user selected
                                
                                
                              )
                            ),
                            
                            
                            mainPanel(
                              tabsetPanel(
                                tabPanel("Plot", plotOutput("corr_plot")), #Show a scatter plot of the selected variables
                                tabPanel("Table",DTOutput("tbl")) #Show a table with the selected variables
                              )
                            )
                          )
                 ),
                 
                 tabPanel("Summary", #New feature 7: a tab with the summary of each species
                          verbatimTextOutput("summary"))
)

server <- function(input, output) {
  
  #Filter data
  filtered_data = reactive(
    iris %>% 
      filter(Species %in% input$selected_species) %>% 
      select(c(input$x_axis,input$y_axis,"Species"))
  )
  
  scatter_plot <- reactive(
    filtered_data() %>% 
      ggplot(aes_string( x = input$x_axis, y = input$y_axis, colour = "Species"))+
      geom_point(alpha = 0.6)+
      scale_colour_manual(values=c("#000000", "#E69F00", "#56B4E9")) + #Color blind friendly palette
      xlim(min(iris[input$x_axis]), max(iris[input$x_axis])) + #Set the limits of the axis so that the plot scale does
      #not change every time a different option is chosen, which is bad for comparing the groups.  
      ylim(min(iris[input$y_axis]), max(iris[input$y_axis]))+
      theme_classic()
  )
  
  output$corr_plot <- renderPlot(
    print(scatter_plot())
    )
  

  output$tbl = renderDT(filtered_data())
  
  output$downloadData = downloadHandler(filename = "iris_exploration_data.csv",
                                        content = function(file) {
                                          write.csv(filtered_data(), file)
                                          })
  
  output$downloadPlot = downloadHandler(
    filename ="iris_exploration_plot.png" ,
    content = function(file) {
      ggsave(file,scatter_plot())
    }
  )
  
  output$summary <- renderPrint({
    iris %>% 
      split(.$Species) %>%
      map(select,-Species) %>% 
      map(summary)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)


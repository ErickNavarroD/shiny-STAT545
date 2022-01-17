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

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title and description of the app
   titlePanel("Exploration of the Iris dataset"),
   "The iris dataset gives measurments in centimeters of the variables sepal length and  width and petal length and width, respectively, for 50 flowers from each of 3 species of iris. The species are Iris setosa, versicolor, and virginica.",
   br(),
   "In this app, you will be able to explore the relationship between each of those variables across the 3 species.",
   br(),
   "Enjoy!",
   br(),br(),
   
   # Sidebar with a checkbox for the species and two options to select the variables to plot in the X and Y axes
   sidebarLayout(
      tabsetPanel(
        sidebarPanel(
          checkboxGroupInput("selected_species", #Feature 1: Select the species to include. This is useful because it
                             #allows the user to observe specific species in the plot. 
                             "Species:",
                             unique(iris$Species)),
          selectInput("x_axis", 
                      "X axis", 
                      names(select(iris, -Species)),
                      selected = "Sepal.Length"), # Feature 2: Select the variable to be in X axis. This is 
                      #useful because it allows the user to select a specific variable in the plot. 
          selectInput("y_axis", 
                      "Y axis",
                      names(select(iris, -Species)),
                      selected = "Sepal.Width") #Featue 3: Select the variable to be in Y axisThis is 
          #useful because it allows the user to select a specific variable in the plot. 
          )
      ),
      
      
      mainPanel(
        tabsetPanel(
          tabPanel("Plot", plotOutput("corr_plot")), #Show a scatter plot of the selected variables
          tabPanel("Table",DTOutput("tbl")) #Show a table with the selected variables
        )
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  #Filter data
  filtered_data = reactive(
    iris %>% 
      filter(Species %in% input$selected_species) %>% 
      select(c(input$x_axis,input$y_axis,"Species"))
  )
  
  #Feature 4: Plot the scatter plot. This is useful because it provies a visualization of the relationship
  #between the selected 2 variables
   output$corr_plot <- renderPlot({
      filtered_data() %>% 
       ggplot(aes_string( x = input$x_axis, y = input$y_axis, colour = "Species"))+
       geom_point(alpha = 0.6)+
       scale_colour_manual(values=c("#000000", "#E69F00", "#56B4E9")) + #Color blind friendly palette
       xlim(min(iris[input$x_axis]), max(iris[input$x_axis])) + #Set the limits of the axis so that the plot scale does
       #not change every time a different option is chosen, which is bad for comparing the groups.  
       ylim(min(iris[input$y_axis]), max(iris[input$y_axis]))+
       theme_classic()
   })
   
   #Feature 5: Render the table with the selected data. This is useful because it lets the user scroll through
   #the filtered data table based on their selections.
   output$tbl = renderDT(filtered_data())
}

# Run the application 
shinyApp(ui = ui, server = server)


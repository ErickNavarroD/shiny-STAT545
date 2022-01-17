# Iris exploration app

Welcome to my iris exploration shiny app! This is part of the [Assignment 3](https://stat545.stat.ubc.ca/assignments/assignment-b3/) of the [STAT545B](https://stat545.stat.ubc.ca) course at the University of British Columbia. 

For this assignment, I decided to design my own shiny app (**Assignment Option B**). Its goal is to provide a dynamic exploration of the variables in the `iris` dataset, which is built-in in R. Briefly, and according to its [R documentation](https://www.rdocumentation.org/packages/datasets/versions/3.6.2/topics/iris), "This famous (Fisher's or Anderson's) iris data set gives the measurements in centimeters of the variables sepal length and width and petal length and width, respectively, for 50 flowers from each of 3 species of iris. The species are Iris setosa, versicolor, and virginica." 

To do so, I included the following features: 
- A checkbox that allows the user to select the species that they want to display
- A tab where the user can select the variable they want to explore and visualize in the x axis of the scatter plot
- A tab where the user can select the variable they want to explore and visualize in the y axis of the scatter plot
- A dynamic scatter plot that changes according to the user's selection of variables and species
- A dynamic table that changes the displayed information according to the user's selection of variables and species

This app can be run in a local R studio session using the [R script](https://github.com/stat545ubc-2021/shiny-ErickNavarroD/blob/main/iris_exploration/app.R) found inside of the iris_exploration folder. BUT, my shiny app is already deployed! You can just access via this link: https://ericknav.shinyapps.io/iris_exploration/. 

Happy data exploration! :star_struck:

# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    #theme = shinytheme("")

    # Application title
    titlePanel("Upload and Explore Data"),
    
    #This is calling the function (csv_input_ui, which is activated in my global.R file)
    ##This is a function that can be run in the ui each time you want to load a csv
    #   And it assigns a unique name (e.g. "datafile") to the input
    #This makes the function repeatable, and unique, so it can be used for different datasets (as shown below). 
            csv_input_ui("datafile", "User data (.csv format)"),
            dataTableOutput("table"),
    
    
            csv_input_ui("datafile2", "User data (.csv format)"),
            dataTableOutput("table2")
        )
    )


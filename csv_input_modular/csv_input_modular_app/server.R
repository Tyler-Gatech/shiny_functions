# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.


# Define server logic 
shinyServer(function(input, output, session) {
    
    #The function, csv_input_serv, is a reactive function that is triggered by input$file
    #input$file is an output of csv_input_ui, specifically the code ("fileInput(ns("file"), label))
    #What is unique about this code, is that it also provides a namespace (e.g. "datafile")
    #So the input$file in csv_input_ui triggers the csv_input_serv function and the callModule function below
    #The callModule function allows to specify the namespace we want to run the function on
    
    datafileA <- callModule(csv_input_serv, "datafile",
                           stringsAsFactors = FALSE)
    
    output$table <- renderDataTable({
        datafileA()
    })
    
    datafileB <- callModule(csv_input_serv, "datafile2",
                           stringsAsFactors = FALSE)
    
    output$table2 <- renderDataTable({
        datafileB()
    })

})

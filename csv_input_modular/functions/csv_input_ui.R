#This is a function that can be run in the ui each time you want to load a csv
#   And it assigns a unique name (i.e. the id inputted) to the function.
#This makes the function repeatable, and unique, so it can be used for different datasets. 
#See the example ui code attached to see how it is used in the ui. 

csv_input_ui <- function(id, label = "CSV file") {
  # Create a namespace function using the provided id
  ns <- NS(id)
  
  tagList(
    #assigns the file tag to the namespace provided in the function above
    fileInput(ns("file"), label),
    checkboxInput(ns("heading"), "Has heading"),
    selectInput(ns("quote"), "Quote", c(
      "None" = "",
      "Double quote" = "\"",
      "Single quote" = "'"
    ))
  )
}
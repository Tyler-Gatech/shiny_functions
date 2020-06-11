## This provides an example of how to modularize a function in shiny using R


## Benefits
Why would you want to modularize a function? 

- Repeatable within and across different apps
- Ensures stability within your code by uniquely identifying similar actions


## Example - Non Modular Function (this is showing the old way first)
How would you typically bring a csv file into Shiny and display as a table?

- Let's say, for example, you want to upload a csv file into Shiny and create a reactive server code that provides a table of the data. 
- Note: Reactive server code looks for a ui input and when it changes, performs some action
- Your ui code will typically look something like this

``` ui <- fluidPage(
      fileInput("file1", "Choose CSV File",
        accept = c(
          "text/csv",
          "text/comma-separated-values,text/plain",
          ".csv")
        ),
         mainPanel(
      tableOutput("contents")
    )
  )


```

- The code above creates an output called input$file1 (we'll get back to the tableOutput piece)
- After this, you need to do something on the server side with this information (see below)
- So you would create server code that reacts to input$file1
- renderTable (below) is the reactive function in this case, and therefore when it notices input$file1 it automatically performs an action



```
server <- function(input, output) {
  output$contents <- renderTable({
    inFile <- input$file1
    
    if (is.null(inFile))
      return(NULL)
    
    read.csv(inFile$datapath, header = input$header)
  })
}
```

The code above says:
- look for input$file1 (from our ui) 
- inFile: grabs the file information
- read.csv: reads the data into r dataframe
- renderTable: creates a shiny object in table format (this literally creates the html) and calls it "contents" 


Now looking back to tableOutput part of the UI again

``` ui <- fluidPage(
      fileInput("file1", "Choose CSV File",
        accept = c(
          "text/csv",
          "text/comma-separated-values,text/plain",
          ".csv")
        ),
         mainPanel(
      tableOutput("contents")
    )
  )


```

- tableOutput renders the html from the server object "contents"

This is the non modular way of inputing a csv into R Shiny, but what if you wanted to input another csv? 
- You can repeat the code. But, this starts to get messy, especially for functions you perform repeatedly
- You can write a function. But, the file names in the functinos are not uniuqe (remember file1 above?). Therefore, everytime you run your function, it will mess up the all the tables you created, because those tables are reactive. 
- The solution? Create a modular function which provides a namespace within the function. 
- The namespace is a unique id that is called in the function, and prevents your reactive code from running unless the namespace is explictly called. 


## Example - Modular Function (this is the new way) 
How can you create a function for brining in csv files that can be repeated within an app and easily shared across apps?

- Create modular functions and call the modular functions in the ui and server environment. 
- In order to call functions in the ui and server environment I create a file called global.R
- global.R files are automatically called ran when an app is opened
- Within the global.r file call (using source(function)) any function that you want ran 

Let's look at the modular functions

csv_input_ui

```
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

```

- This is very similar to our original ui code (above at top)
- it creates an input$file
- The unique piece is the ns part , that now allows the user to define a name space and repeat the function with a unique id
- Once again, this is necessary for reactive coding, because we don't want the reactive code to change every output each time we upload a new dataset

Now, looking at the ui

```
shinyUI(fluidPage(
    
    
            csv_input_ui("datafile", "User data (.csv format)"),
            dataTableOutput("table"),
    
            csv_input_ui("datafile2", "User data (.csv format)"),
            dataTableOutput("table2")
        )
    )
    
```

- This code is very clean and simple. 
- csv_input_ui is running the function above, and for the first iteration gives it the namespace "datafile1", and for the 2nd iteration "datafile2"
- this creates input$file, but with a unique namespace

Now viewing the server function 

```
csv_input_serv <- function(input, output, session, stringsAsFactors) {
  # The selected file, if any
  userFile <- reactive({
    # If no file is selected, don't do anything
    validate(need(input$file, message = FALSE))
    input$file
  })
  
  # The user's data, parsed into a data frame
  dataframe <- reactive({
    read.csv(userFile()$datapath,
             header = input$heading,
             quote = input$quote,
             stringsAsFactors = stringsAsFactors)
  })
  
  # Return the reactive that yields the data frame
  return(dataframe)
}
```

- Note: There is no reference to the namespace here, it is simply running a basic function
- The namespace (e.g. "datafile") is made explicit in the server.R file

The server.R file 

```

    datafileA <- callModule(csv_input_serv, "datafile",
                           stringsAsFactors = FALSE)
    
    output$table <- renderDataTable({
        datafileA()
    })
    
    
```

- The callModule function runs the csv_input_serv function within the specified nameSpace
- renderDataTable creates our html for our ui


Back to the ui 

```
dataTableOutput("table")

```

So there you have it. It's a little complex at first, but once you get the hang of it, this becomes really valuable

## Key Benefits
- Repeatable Code (we can put these functions in any R Shiny App) 
- Streamlined code (we only have to call the functions in the Ui and Server)
- Stable environment (we don't have to worry about a reactive element reacting to the wrong element) 

This maybe an unecessary example, loading multiple csv's, but it illustrates the point clearly. Download the app and try running it yourself


## Basic Process Flow of the Modular App
- ui.R calls the csv_input_ui function
- namespace and input$file is created
- server.R reacts and runs csv_input_serv function for the specified namespace
- ui displays output of server.R

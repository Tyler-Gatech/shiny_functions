#Functions
library(shiny)
library(shinythemes)
library(markdown)
library(ggplot2)
library(tidyverse)
library(shinydashboard)
library(DT)
library(plotly)


options(shiny.maxRequestSize = 1024^3)

source("../functions/top_column_counts.R")
source("../functions/percent.R")
source("../functions/log_10_indicator_for_graphs.R")
source("../functions/csv_input_ui.R")
source("../functions/csv_input_serv.R")
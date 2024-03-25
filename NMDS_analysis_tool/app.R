# Load libraries
library(shiny)
library(ggplot2)
library(vegan)
library(ggforce)
library(DT)
library(rsconnect)

# Define UI
ui <- fluidPage(
  titlePanel("NMDS Analysis Tool"),
  tabsetPanel(
    tabPanel("NMDS Visualization",
             sidebarLayout(
               sidebarPanel(
                 fileInput("file_nmds", "Choose CSV File",
                           accept = c("text/csv",
                                      "text/comma-separated-values,text/plain",
                                      ".csv")),
                 helpText("Note: Please upload a CSV file with binary matrix data.")
               ),
               mainPanel(
                 plotOutput("nmdsPlot")
               )
             )
    ),
    tabPanel("CSV Data Preprocessing",
             sidebarLayout(
               sidebarPanel(
                 fileInput("file_csv", "Choose CSV File",
                           accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv")),
                 selectInput("variable_1_select", "Select variable_1", NULL),
                 selectInput("variable_2_select", "Select variable_2", NULL)
               ),
               mainPanel(
                 DTOutput("table"),
                 verbatimTextOutput("unique_variable_1"),
                 verbatimTextOutput("unique_variable_2"),
                 #DTOutput("binary_matrix"),
                 downloadButton("save_button", "Save Binary Matrix")
               )
             )
    )
  )
)

# Define server
server <- function(input, output, session) {
  
  # Read data for NMDS
  data_LAN <- reactive({
    inFile <- input$file_nmds
    if (is.null(inFile)) return(NULL)
    read.csv(inFile$datapath, header = TRUE, row.names = 1)
  })
  
  # Perform NMDS and create plot
  output$nmdsPlot <- renderPlot({
    req(data_LAN())
    
    dfNmds <- metaMDS(data_LAN(), distance = "bray", k = 2, trymax = 100)
    data <- data.frame(dfNmds$points)
    
    ggplot(data, aes(x = MDS1, y = MDS2)) +
      geom_point(size = 2) +
      theme_classic() +
      geom_text(
        aes(label = rownames(data)),
        vjust = 1.5,
        size = 3,
        color = "black"
      ) +
      labs(
        subtitle = paste("stress=", round(dfNmds$stress, 3), sep = "")
      )
  })
  
  # Read data for CSV Viewer
  data_csv <- reactive({
    req(input$file_csv)  # Ensure file is selected
    read.csv(input$file_csv$datapath)
  })
  
  # Update dropdown options
  observe({
    col_options <- names(data_csv())
    updateSelectInput(session, "variable_1_select", choices = col_options)
    updateSelectInput(session, "variable_2_select", choices = col_options)
  })
  
  # Reactive value to store binary matrix
  binary_matrix <- reactiveVal(NULL)
  
  # Selected data for CSV Viewer
  selected_data <- reactive({
    req(input$variable_1_select, input$variable_2_select)
    data_selected <- data_csv()[, c(input$variable_1_select, input$variable_2_select), drop = FALSE]
    colnames(data_selected) <- c("variable_1", "variable_2")
    
    # Create binary matrix
    binary_matrix_data <- table(data_selected$variable_1, data_selected$variable_2)
    binary_matrix_data[binary_matrix_data > 1] <- 1
    binary_matrix(binary_matrix_data)  # Store binary matrix in reactive value
    
    data_selected
  })
  
  # Display selected rows
  output$table <- renderDT({
    datatable(selected_data())
  })
  
  
  # Display unique rivers
  output$unique_variable_1 <- renderPrint({
    unique_variable_1 <- unique(selected_data()$variable_1)
    cat("Unique variable_1: ", paste(unique_variable_1, collapse = ", "))
  })
  
  
  # Display unique species
  output$unique_variable_2 <- renderPrint({
    unique_variable_2 <- unique(selected_data()$variable_2)
    cat("Unique variable_2: ", paste(unique_variable_2, collapse = ", "))
  })
  
  
  
  # Display binary matrix
  output$binary_matrix <- renderDT({
    datatable(binary_matrix())
  })
  
  # Save binary matrix
  output$save_button <- downloadHandler(
    filename = function() {
      paste("binary_matrix_", input$file_csv$name, sep = "")
      
    },
    content = function(file) {
      # Use isolate to prevent reactiveValues from being accessed reactively
      write.csv(isolate(binary_matrix()), file, row.names = TRUE)
    }
  )
  
}

# Run the Shiny app
shinyApp(ui = ui, server = server)

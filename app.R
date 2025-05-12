library(shiny)
library(dplyr)
library(plotly)
library(bslib)
library(readr)
library(treemapify)

source("data_prep.R")

# Define UI
ui <- fluidPage(
  theme = bs_theme(bootswatch = "darkly"),
  titlePanel("Interactive Budget & Expenses Dashboard"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("month", "Select Month:", choices = unique(expenses_joined$month), selected = "may"),
      sliderInput("amount_range", "Amount Range:", min = 0, max = 5000, value = c(0, 500), step = 10),
      
      uiOutput("category_ui"),
      
      div(
        actionButton("select_all", "Select All"),
        actionButton("deselect_all", "Deselect All"),
        style = "margin-bottom: 15px;"
      ),
      
      div(downloadButton("download_budget", "Download Budget Data"), style = "margin-bottom: 15px;"),
      div(downloadButton("download_expenses", "Download Expenses Data"))
    ),
    
    mainPanel(
      fluidRow(
        column(6, plotlyOutput("total_budget_expenses_bar")),
        column(6, plotlyOutput("expenses_treemap", height = "400px"))
      ),
      br(),
      fluidRow(
        column(6, plotlyOutput("budget_plot")),
        column(6, plotlyOutput("expenses_plot"))
      )
    )
  )
)

# Define Server
server <- function(input, output, session) {
  
  # Reactive for available categories based on filters
  available_categories <- reactive({
    expenses_joined %>%
      filter(month == input$month,
             amount >= input$amount_range[1],
             amount <= input$amount_range[2]) %>%
      pull(category.y) %>%
      unique()
  })
  
  # Dynamic UI for category selection
  output$category_ui <- renderUI({
    selectInput("category", "Select Category:",
                choices = available_categories(),
                selected = available_categories(),
                multiple = TRUE)
  })
  
  # Select All button
  observeEvent(input$select_all, {
    updateSelectInput(session, "category", selected = available_categories())
  })
  
  # Deselect All button
  observeEvent(input$deselect_all, {
    updateSelectInput(session, "category", selected = character(0))
  })
  
  # Filtered Budget Data
  filtered_budget <- reactive({
    budget_joined %>%
      filter(month == input$month,
             amount >= input$amount_range[1],
             amount <= input$amount_range[2],
             category.y %in% input$category
      ) %>%
      group_by(category.y) %>%
      summarise(total = sum(amount, na.rm = TRUE)) %>%
      mutate(percentage = total / sum(total),
             label = paste0(category.y, ": ", scales::percent(percentage)))
  })
  
  # Filtered Expenses Data
  filtered_expenses <- reactive({
    expenses_joined %>%
      filter(month == input$month,
             amount >= input$amount_range[1],
             amount <= input$amount_range[2],
             category.y %in% input$category
      ) %>%
      group_by(category.y) %>%
      summarise(total = sum(amount, na.rm = TRUE)) %>%
      mutate(percentage = total / sum(total),
             label = paste0(category.y, ": ", scales::percent(percentage)))
  })
  
  # Budget Plot
  output$budget_plot <- renderPlotly({
    data <- filtered_budget()
    
    plot_ly(
      data,
      labels = ~category.y,
      values = ~total,
      type = "pie",
      textinfo = "label+percent",
      insidetextorientation = "radial",
      hole = 0.4
    ) %>%
      layout(
        title = paste("Budget for", input$month),
        showlegend = FALSE,
        paper_bgcolor = "#2c2f37",
        plot_bgcolor = "#2c2f37",
        font = list(color = "white")
      )
  })
  
  # Expenses Plot
  output$expenses_plot <- renderPlotly({
    data <- filtered_expenses()
    
    plot_ly(
      data,
      labels = ~category.y,
      values = ~total,
      type = "pie",
      textinfo = "label+percent",
      insidetextorientation = "radial",
      hole = 0.4
    ) %>%
      layout(
        title = paste("Expenses for", input$month),
        showlegend = FALSE,
        paper_bgcolor = "#2c2f37",
        plot_bgcolor = "#2c2f37",
        font = list(color = "white")
      )
  })
  
  # Total Budget and Expenses Bar Chart
  output$total_budget_expenses_bar <- renderPlotly({
    total_budget <- sum(filtered_budget()$total, na.rm = TRUE)
    total_expenses <- sum(filtered_expenses()$total, na.rm = TRUE)
    
    bar_data <- data.frame(
      category = c("Total Budget", "Total Expenses"),
      amount = c(total_budget, total_expenses)
    )
    
    plot_ly(bar_data, x = ~category, y = ~amount, type = 'bar', text = ~paste('$', amount),
            textposition = 'outside', marker = list(color = c('blue', 'red'))) %>%
      layout(
        title = paste("Total Budget and Expenses for", input$month),
        xaxis = list(title = "Category"),
        yaxis = list(title = "Amount ($)"),
        showlegend = FALSE,
        paper_bgcolor = "#2c2f37",
        plot_bgcolor = "#2c2f37",
        font = list(color = "white")
      )
  })
  
  # Treemap Plot for Expenses
  output$expenses_treemap <- renderPlotly({
    data <- filtered_expenses()
    
    if (nrow(data) > 0) {
      plot_ly(
        data,
        type = "treemap",
        labels = ~category.y,
        parents = rep("", nrow(data)),
        values = ~total,
        textinfo = "label+value+percent entry",
        hoverinfo = "label+value+percent entry",
        marker = list(
          colors = scales::col_numeric(palette = "Viridis", domain = NULL)(data$total),
          line = list(color = "white", width = 1)
        )
      ) %>%
        layout(
          title = paste("Expenses Treemap for", input$month),
          paper_bgcolor = "#2c2f37",
          plot_bgcolor = "#2c2f37",
          font = list(color = "white")
        )
    } else {
      plot_ly() %>%
        layout(
          title = paste("No data available for", input$month),
          paper_bgcolor = "#2c2f37",
          plot_bgcolor = "#2c2f37",
          font = list(color = "white")
        )
    }
  })
  
  # Download Budget Data
  output$download_budget <- downloadHandler(
    filename = function() {
      paste("budget_data_", input$month, ".csv", sep = "")
    },
    content = function(file) {
      write_csv(filtered_budget(), file)
    }
  )
  
  # Download Expenses Data
  output$download_expenses <- downloadHandler(
    filename = function() {
      paste("expenses_data_", input$month, ".csv", sep = "")
    },
    content = function(file) {
      write_csv(filtered_expenses(), file)
    }
  )
}

# Run the app
shinyApp(ui, server)
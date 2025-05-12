if(!require("pacman")) install.packages("pacman")

pacman::p_load(DBI,
               RPostgres,
               dplyr,
               ggplot2,
               scales, # for percent format,
               plotly,
               treemapify,
               ggpubr,
               shiny,
               bslib,
               readr
)

# Connect to PostgreSQL
#con <- dbConnect(
#  RPostgres::Postgres(),
#  dbname   = Sys.getenv("DB_NAME", "postgres"),
#  host     = Sys.getenv("DB_HOST", "host.docker.internal"),  # Required on macOS/Windows
#  user     = Sys.getenv("DB_USER", "postgres"),
#  password = Sys.getenv("DB_PASS", "")
#  port     = as.integer(Sys.getenv("DB_PORT", 5438)),
#)

con <- dbConnect(
  RPostgres::Postgres(),
  host     = "localhost",     # replace with your host if not using host.docker.internal
  dbname   = "postgres",      # replace with your database name
  user     = "postgres",      # replace with your user
  port     = 0000,            # replace with your port if needed
  password = "xxxxxxxxxxxxx"  # replace with your password
)



# Connect to schema
dbGetQuery(con, "SELECT schema_name FROM information_schema.schemata")

# Example: List tables
dbListTables(con)

dbGetQuery(con, "
  SELECT table_name
  FROM information_schema.tables
  WHERE table_schema = 'income_and_expenses'
    AND table_type = 'BASE TABLE'
")

# Or already set path
dbExecute(con, "SET search_path TO income_and_expenses")

# Load budget data
expenses <- dbReadTable(con, "expenses")
budget <- dbReadTable(con, "budget")
categories <- dbReadTable(con, "categories")

# Preprocess data
budget_joined <- left_join(budget, categories, by = c("category" = "cat_id"))
expenses_joined <- left_join(expenses, categories, by = c("category" = "cat_id"))
#budget_joined <- budget_raw |> mutate(month = tolower(month))
#expenses_joined <- expenses_raw |> mutate(month = tolower(month))

# Disconnect
dbDisconnect(con)


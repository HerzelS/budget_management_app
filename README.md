---
title: "Budget & Expenditure Tracker"
output: github_document
---

# 📊 Budget & Expenditure Tracker (Shiny + PostgreSQL + Docker)

This Shiny app visualizes and tracks budget allocations and expenditures using data stored in a PostgreSQL database. The app connects to a Dockerized PostgreSQL instance, joins data from multiple tables in R, and renders interactive dashboards for financial insights.

## 🚀 Features

- Connects securely to a PostgreSQL database (running via Docker).
- Joins `budget`, `expenses`, and `categories` tables in R.
- Prepares cleaned and merged data using `dplyr`.
- Launches a user-friendly Shiny dashboard to:
  - Track budget versus actual spending
  - Visualize expenditure categories
  - Compare trends over time using interactive charts

## 🧰 Tech Stack

- **R + Shiny** for data handling and dashboard UI  
- **PostgreSQL** for relational data storage  
- **Docker** for local development and deployment  
- Libraries: `DBI`, `RPostgres`, `dplyr`, `ggplot2`, `plotly`, `treemapify`, `ggpubr`, `bslib`, and others

## 📁 Repository Structure

---
title: "Budget & Expenditure Tracker"
output: github_document
---

# 📊 Budget & Expenditure Tracker (Shiny + PostgreSQL + Docker)

This Shiny app visualizes and tracks budget allocations and expenditures using data stored in a PostgreSQL database. The app connects to a Dockerized PostgreSQL instance, joins data from multiple tables in R, and renders interactive dashboards for financial insights.

## 🚀 Features

- Connects securely to a PostgreSQL database (running via Docker).
- Joins `budget`, `expenses`, and `categories` tables in R.
- Prepares cleaned and merged data using `dplyr`.
- Launches a user-friendly Shiny dashboard to:
  - Track budget versus actual spending
  - Visualize expenditure categories
  - Compare trends over time using interactive charts

## 🧰 Tech Stack

- **R + Shiny** for data handling and dashboard UI  
- **PostgreSQL** for relational data storage  
- **Docker** for local development and deployment  
- Libraries: `DBI`, `RPostgres`, `dplyr`, `ggplot2`, `plotly`, `treemapify`, `ggpubr`, `bslib`, and others

## 📁 Repository Structure

---
title: "Budget & Expenditure Tracker"
output: github_document
---

# 📊 Budget & Expenditure Tracker (Shiny + PostgreSQL + Docker)

This Shiny app visualizes and tracks budget allocations and expenditures using data stored in a PostgreSQL database. The app connects to a Dockerized PostgreSQL instance, joins data from multiple tables in R, and renders interactive dashboards for financial insights.

## 🚀 Features

- Connects securely to a PostgreSQL database (running via Docker).
- Joins `budget`, `expenses`, and `categories` tables in R.
- Prepares cleaned and merged data using `dplyr`.
- Launches a user-friendly Shiny dashboard to:
  - Track budget versus actual spending
  - Visualize expenditure categories
  - Compare trends over time using interactive charts

## 🧰 Tech Stack

- **R + Shiny** for data handling and dashboard UI  
- **PostgreSQL** for relational data storage  
- **Docker** for local development and deployment  
- Libraries: `DBI`, `RPostgres`, `dplyr`, `ggplot2`, `plotly`, `treemapify`, `ggpubr`, `bslib`, and others

## 📁 Repository Structure

.
├── app.R # Shiny UI and server logic
├── data_prep.R # PostgreSQL connection and data preparation
├── Dockerfile # Dockerfile for containerizing the app
└── README.md # You're here



## 🐳 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/budget-tracker-shiny.git
cd budget-tracker-shiny
```

2. Set Up PostgreSQL (Dockerized)
Create a docker-compose.yml file or use the following command to spin up PostgreSQL:

```r
docker run --name pg-docker \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=yourpassword \
  -e POSTGRES_DB=postgres \
  -p 5432:5432 \
  -d postgres
```

Import your schema and sample data into the `income_and_expenses` schema, or a schema of your choice in your database.

3. Edit Connection Settings
In `data_prep.R`, update the connection details if needed:

```r
con <- dbConnect(
  RPostgres::Postgres(),
  host     = "localhost",
  dbname   = "postgres",
  user     = "postgres",
  port     = 5432,
  password = "yourpassword"
)
```

Alternatively, use environment variables for security.

```r
# Install required packages
source("data_prep.R")
shiny::runApp("app.R")
```

Or use:

```r
Rscript app.R
```

📦 Docker Build (Optional)

To containerise the Shiny app:

```bash
docker build -t budget-tracker-app .
docker run -p 3838:3838 budget-tracker-app
```

✅ To-Do

* Add user authentication
* Add data upload feature via UI
* Deploy on ShinyApps.io or RStudio Connect

📄 License
MIT License. See LICENSE for details.

🤝 Contributing
Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.







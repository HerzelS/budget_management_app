# Use R base image with Shiny
FROM rocker/shiny:latest

# Install system dependencies (optional but needed for some R packages)
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libpq-dev  # Added to support PostgreSQL connections from R

# Install R packages
RUN R -e "install.packages(c('shiny', 'dplyr', 'plotly', 'bslib', 'readr', 'treemapify', 'DBI', 'RPostgres'))"

# Install pacman for managing R packages (optional but useful)
RUN R -e "install.packages('pacman')"

# Copy your Shiny app files (including app.R, data_prep.R, etc.)
COPY . /srv/shiny-server/

# Make the app folder and its contents readable by Shiny user
RUN chown -R shiny:shiny /srv/shiny-server/

# Set environment variables for database connectivity
ENV DB_HOST=host.docker.internal
ENV DB_PORT=5438
ENV DB_NAME=postgres
ENV DB_USER=postgres
ENV DB_PASS=Matipa@18092023

# Expose the default port for Shiny Server
EXPOSE 3838

# Start Shiny Server
CMD ["/usr/bin/shiny-server"]

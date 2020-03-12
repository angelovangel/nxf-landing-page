# dashboard used for landing page of the nxf pipelines at NCCT
# maintainer
# aangeloo@gmail.com

library(shinydashboard)
library(shinyWidgets)
library(shinyjs)
library(pingr) # get status of apps
library(parallel)
library(loggit)


ui <- dashboardPage(
  title = "nxf-pipelines at NCCT",
  dashboardHeader(disable = TRUE),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    includeCSS("css/custom.css"),
    shinyjs::useShinyjs(),
    
    tags$h1("Nextflow pilelines at NCCT/Microbiology"),
    tags$footer( paste("last update: ", file.info("app.R")$mtime) ),
    tags$hr(),
    tags$hr(),
        fluidRow(
          # app1
          column(width = 4,
            infoBoxOutput("ibox1", width = NULL),
            dropdown(tags$h4(tags$a(href = "https://github.com/angelovangel/nextflow-bcl", 
                                    target = "_blank",
                                    "angelovangel/nextflow-bcl")), 
                   tags$p(
                     HTML("A simple nextflow pipeline for obtaining Illumina run metrics (InterOp) and 
                          generation of fastq files (bcl2fastq). The input is an Illumina run folder 
                          and a SampleSheet.csv file.")
                     ),
                   style = "minimal", 
                   label = "info", 
                   width = "100%",
                   icon = icon("align-justify"), 
                   status = "success",
                   size = "sm")
          ),
          #app2
          column(width = 4,
            infoBoxOutput("ibox2", width = NULL),
            dropdown(tags$h4(tags$a(href = "https://github.com/angelovangel/nextflow-fastp", 
                                    target = "_blank",
                                    "angelovangel/nextflow-fastp")), 
                     tags$p(
                       HTML("This pipeline executes fastp on fastq files (PE or SE) in a directory, 
                            saves the filtered files in results-fastp/fastp_trimmed, 
                            and generates a MultiQC report.")
                     ),
                     style = "minimal", 
                     label = "info", 
                     width = "100%",
                     icon = icon("align-justify"), 
                     status = "success",
                     size = "sm")
          ),
          # app3
          column(width = 4,
            infoBoxOutput("ibox3", width = NULL),
            dropdown(tags$h4(tags$a(href = "https://nf-co.re/bacass", 
                                    target = "_blank", 
                                    "nf-core/bacass")), 
                   tags$p(
                     HTML("This pipeline performs de novo bacterial assembly of next-generation sequencing reads. 
                          It can be used for short-read/long-read/hybrid assemblies, mainly using Unicycler. 
                          Includes quality trim of your reads and performs basic sequencing QC.
                          Contamination of the assembly is checked using Kraken2 to verify sample purity.
                          In all cases, the assembly is assessed (QUAST) and annotated (Prokka).")
                   ),
                   style = "minimal", 
                   label = "info", 
                   width = "100%",
                   icon = icon("align-justify"), 
                   status = "success",
                   size = "sm")
          )
        ),
    tags$hr(),
    tags$hr(),
        fluidRow(
          # app4
          column(width = 4,
                 infoBoxOutput("ibox4", width = NULL),
                 dropdown(tags$h4(tags$a(href = "https://nf-co.re/bacass", 
                                         target = "_blank", 
                                         "nf-core/mag")), 
                          tags$p(
                            HTML("This pipeline performs taxonomic assignment of metagenomic reads(centrifuge and/or kraken2),
                                 assembly (megahit and spades), 
                                 binning (metabat2) and annotation of metagenomes. It supports both short and long reads")
                          ),
                          style = "minimal", 
                          label = "info", 
                          width = "100%",
                          icon = icon("align-justify"), 
                          status = "success",
                          size = "sm")
          )
        )
  )
)

server <- function(input, output, session) { 
  options(shiny.launch.browser = TRUE)
  source("renderAppBox.R", local = TRUE)
  
  # app1
  output$ibox1 <- renderAppBox(app_name = "bcl", 
                               app_ip = "google.com", 
                               channel_name = "aa-nextflow", 
                               invalidate_interval = 5000, 
                               userlog_path = "../nextflow-bcl-shiny/userlog") # where to put the other apps?
  # app2
  output$ibox2 <- renderAppBox(app_name = "fastp",
                               app_ip = "google.com", 
                               channel_name = "aa-nextflow", 
                               invalidate_interval = 5000, 
                               userlog_path = "../nextflow-fastp-shiny/userlog")
    
  # app3
  output$ibox3 <- renderAppBox(app_name = "nf-core/bacass",
                               app_ip = "blabla",
                               channel_name = "nf-core",
                               invalidate_interval = 5000, 
                               userlog_path = "../nextflow-fastp-shiny/userlog")
  
  # app4
  output$ibox4 <- renderAppBox(app_name = "nf-core/mag",
                               app_ip = "blabla",
                               channel_name = "nf-core",
                               invalidate_interval = 5000, 
                               userlog_path = "../nextflow-fastp-shiny/userlog")
  
  
}


shinyApp(ui, server)

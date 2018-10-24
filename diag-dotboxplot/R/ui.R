#### 
## UI - DOTPLOT
#rm(list=ls())
library(shiny)

shinyUI(
  fluidPage(
    sidebarLayout(
      ## sidebar w checkboxes
      sidebarPanel(
        h4("Select organ"),
        selectInput("organ", "Organ:",
                    c("Kidney"="niere",
                      "Liver"="leber",
                      "Lungs" ="lunge",
                      "Pancreas" ="pankreas")),
        h4("Select variable"),
        selectInput("var", "Variable:",
                    c( "Inpatient Days"="Inpatient_Days",
                      "ICU Status"="ICU_Status",                 
                       "ICU days"="ICU_Days",
                       
                       "Duration surgery"="Duration_Surgery"      ,     
                       "Duration surgery 2"="Duration_Surgery.1",
                       "CI polyneuropathy"="CI_polyneuropathy"  ,
                       "CI myopathy"= "CI_myopathy"    ,
                       "Leukoencephalopathy"      ="Leukoencephalopathy"  ,
                         "Ischemia transplanted organ" =   "Ischemia_Transplanted_Organ",
                       "EKs" = "EKs"         ,               
                       "TKs" = "TKs"      ,
                       "FFPs" ="FFPs",
                       "Primary_Graft_Dysfunction"= "Primary_Graft_Dysfunction"
                    )),
        h4("Select summary statistic"),
        selectInput("meanfun", "Summarizing statistic:",
                    c("Mean"="mean","Median"="median")),
        
        tags$style(".well {background-color:#FFFFFF;}")
      ),
      ## plot
      mainPanel(
        tabsetPanel(
            tabPanel("Graph", plotOutput("plot")),
          tabPanel("Data", dataTableOutput("table"))
        )
        #    verbatimTextOutput("event")
      ))
  )
)


#shinyApp(ui, server)

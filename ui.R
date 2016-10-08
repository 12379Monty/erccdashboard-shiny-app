
fluidPage(
  titlePanel("erccdashboard"),
  
    sidebarLayout(
      sidebarPanel(
      
        fileInput('exTable', 'Choose CSV File of Raw Data to Upload', accept=c('text/csv', 'text/comma-separated-values,text/plain', 
                                                                             '.csv')),
      
        tags$hr(),
      
        checkboxInput('header', 'Header', TRUE),
      
        radioButtons('sep', 'Separator', c(Comma=',', Semicolon=';', Tab='\t'), ','),
      
        radioButtons('datType', 'Data Type', c(count='count', array='array')),
      
        textInput('sample1Name', 'Sample 1 Name', value= 'e.g., MET'),
      
        textInput('sample2Name', 'Sample 2 Name', value= 'e.g., CTL'),
      
        numericInput('erccdilution', 'Dilution Factor for Ambion Spike-In Mixtures',value= 0.01, step=.01, min=0),
      
        numericInput('spikeVol', 'Volume (uL) of Diluted Spike-In Mixture added to Total RNA', value= 1.0, step=.25, min=0),
      
        numericInput('totalRNAmass', 'Mass (ug) of Total RNA', value= 0.5, step=.01, min=0),
      
        numericInput('choseFDR', 'Define False Discovery Rate (FDR)', value= 0.05, step=.01, min=0),
      
        textInput('filenameRoot', 'File Name Prefix for Output Files', value= ""),
        
        actionButton("go", "Run!"),
        
        p("Once all information has been entered or updated click \"Run!\" to run the erccdashbord")

    ),
    
    mainPanel( 
      tabsetPanel(type= "tabs", 
        tabPanel("Data Table", tableOutput('Data')),
                  
        tabPanel("erccdashboard Plots", 
          #ordering of plotOutputs here dictates their order of display in app
          h4(textOutput("lodr")),
            plotOutput("PlotLODR", click = "user_click1", brush = "user_brush1"),
              DT::dataTableOutput("table1"),
                           
          h4(textOutput("dr")),
            plotOutput("PlotDR", click = "user_click2", brush = "user_brush2"),
              DT::dataTableOutput("table2"),
                           
          h4(textOutput("ma")),
            plotOutput("PlotMA", click = "user_click3", brush = "user_brush3"),
              DT::dataTableOutput("table3"),
                           
          h4(textOutput("roc")),
            plotOutput("PlotROC", click = "user_click4", brush = "user_brush4"),
              DT::dataTableOutput("table4")
        ),
                  
        tabPanel("Additional Plots", 
          h4(textOutput("effects")),
            plotOutput("PlotEffects", click = "user_click5", brush = "user_brush4")
        ),
                  
        tabPanel("Console Output", 
            verbatimTextOutput("console")
        )
      )
    )
  ) 
)



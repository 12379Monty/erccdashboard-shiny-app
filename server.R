function(input, output) {
  
  output$Data <- renderTable({
    
    if (is.null(input$exTable))
      return(NULL)
    
    inFile <- input$exTable
    read.csv(inFile$datapath, header=input$header, sep=input$sep, row.names=1)
    
  })
  #LODR
  # observeEvent(input$user_click1, interaction_type <<- "click")
  # observeEvent(input$user_brush1, interaction_type <<- "brush")
  
  #DR
  observeEvent(input$user_click2, interaction_type <<- "click")
  observeEvent(input$user_brush2, interaction_type <<- "brush")
  
  #MA
  observeEvent(input$user_click3, interaction_type <<- "click")
  observeEvent(input$user_brush3, interaction_type <<- "brush")
  
  #ROC
  # observeEvent(input$user_click4, interaction_type <<- "click")
  # observeEvent(input$user_brush4, interaction_type <<- "brush")
  
  #Effects
  # observeEvent(input$user_click5, interaction_type <<- "click")
  # observeEvent(input$user_brush5, interaction_type <<- "brush")
  
  
  runDB <- eventReactive(input$go, {  
    
    inFile <- input$exTable
    
    data <- read.csv(inFile$datapath,header=input$header, sep=input$sep, row.names=1)

    dash <- runDashboard(datType = input$datType, isNorm = FALSE, exTable = data ,
                         repNormFactor = NULL, filenameRoot = input$filenameRoot,
                         sample1Name = input$sample1Name, sample2Name = input$sample2Name,
                         erccmix = "RatioPair", erccdilution = input$erccdilution , spikeVol = input$spikeVol,
                         totalRNAmass = input$totalRNAmass, choseFDR = input$choseFDR, ratioLim = c(-4, 4), 
                         signalLim = c(-14,14), userMixFile = NULL)
    
    # The following was an attempt to capture the console output and add it to the exDat list.  I had hoped I could
    # do this and call this list member to be displayed in console output tab.  I noticed two things when doing it this
    # was as opposed to another reactive function such as out() below.
    # 1) In app when you click on "console output" tab first runDB() returns both the console and exDat list as 
    # desired however when "erccdashboard plots" is clicked no LODR plot displays.  
    # 2) When "erccdashboard plots" tab is clicked first, all plots display as expected however when "console output"
    # is clicked only the exDat list is returned, no console output. Since there appears to be an issue with LODR the problem could
    # be due to the auto printing of LODR with grid.arrange, would be interesting to try this again once
    # dashboard code is update to eliminate LODR auto print
    
     #console.out <- capture.output(dash)
     #dash$console.out <- console.out 
    
    return(dash)
    
  })

  # This function is used to print console output to app. It seems like I shouldn't need an additonal
  # reactive function to do this but this was the only way to get the console output otherwise the list
  # object was just returned.  With this function both the console output and list object are returned
  # within the Console Output tab in the app however this slows down the app as the runDashboard function 
  # # is run twice. The purpose of reactive is to minimize re-running of functions this defeats that purpose.
  console.out <- reactive({

    inFile <- input$exTable
    data <- read.csv(inFile$datapath,header=input$header, sep=input$sep, row.names=1)

    dash <- runDashboard(datType = input$datType, isNorm = FALSE, exTable = data ,
                         repNormFactor = NULL, filenameRoot = input$filenameRoot,
                         sample1Name = input$sample1Name, sample2Name = input$sample2Name,
                         erccmix = "RatioPair", erccdilution = input$erccdilution , spikeVol = input$spikeVol,
                         totalRNAmass = input$totalRNAmass, choseFDR = input$choseFDR, ratioLim = c(-4, 4), signalLim = c(-14,14), userMixFile = NULL)

    output <- capture.output(dash)
    return(output)
  })
  
  #lodr <- reactive({})

  dr <- reactive({
    user_brush <- input$user_brush2
    user_click <- input$user_click2
    DR <- runDB()$Results$dynRangeDat
    EI <- runDB()$idCols
    data <- merge(EI, DR, by.x = "Feature", by.y="Feature")
    data <- data[-c(4:6)]
    if(interaction_type == "brush") tbl <- brushedPoints(data, user_brush)
    if(interaction_type == "click") tbl <- nearPoints(data, user_click, threshold = 10, maxpoints = 1)
    return(tbl)
  })
  
  ma <- reactive({
    user_brush <- input$user_brush3
    user_click <- input$user_click3
    MA <- runDB()$Results$maDatAll
    EI <- runDB()$idCols
    data <- merge(EI, MA, by.x = "Feature", by.y="Feature")
    data <- data[-c(4:13)]
    if(interaction_type == "brush") tbl <- brushedPoints(data, user_brush)
    if(interaction_type == "click") tbl <- nearPoints(data, user_click, threshold = 10, maxpoints = 1)
    return(tbl)
  })
  
  #roc <- reactive({})
  
  #effects <- reactive({})
  
  output$Data <- renderTable({
    
    if (is.null(input$exTable))
      return(NULL)
    
    inFile <- input$exTable
    read.csv(inFile$datapath, header=input$header, sep=input$sep, row.names=1)
    
  })
  
  output$lodr <- renderText("Limit of Detection of Ratios (LODR) Plot")
  output$PlotLODR <- renderPlot({runDB()$Figures$lodrERCCPlot})
  #output$table1 <- DT::renderDataTable({DT::datatable(dr())})
  
  output$dr <- renderText("Dynamic Range Plot")
  output$PlotDR <- renderPlot({runDB()$Figures$dynRangePlot})
  output$table2 <- DT::renderDataTable({DT::datatable(dr())})

  output$ma <- renderText("MA Plot")
  output$PlotMA <- renderPlot({runDB()$Figures$maPlot})
  output$table3 <- DT::renderDataTable({DT::datatable(ma())})

  output$roc <- renderText("ROC Plot")
  output$PlotROC <- renderPlot({runDB()$Figures$rocPlot})
  #output$table4 <- DT::renderDataTable({DT::datatable(dr())})

  output$effects <- renderText("ERCC Effects Plot")
  output$PlotEffects <- renderPlot({runDB()$Figures$rangeResidPlot})
  #output$table5 <- DT::renderDataTable({DT::datatable(dr())})
  
  output$console <- renderPrint({console.out()})
 
}

## SERVER DOTPLOT
shinyServer(function(input, output) {
  output$plot <-renderPlot({
##   da<-get(input$dataset)
 #   sc<-ifelse(input$scale, TRUE, FALSE)
  #  sm<-input$smooth
    makeplot(data=data1, org=input$organ, var=input$var, meanfunction = input$meanfun)
  })
 output$table <- renderDataTable({
maketable(data=data1, var=input$var, org=input$organ) })
  #  output$event <- renderPrint({
  #    d <- event_data("plotly_hover")
  #    if (is.null(d)){"DC = "} 
  #    else{ d}#paste0("DC = ", round(abs(d$y),1), "%")}
  #})
}
)

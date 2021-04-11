ui=shinyUI(fluidPage(pageWithSidebar(
    headerPanel("Header1"),
    sidebarPanel(
        fileInput('layer', 'Choose Layer', multiple=FALSE, accept='asc'),
        fileInput('shape', 'Choose gml', multiple=FALSE, accept="gml")
        
    ),
    mainPanel(
        plotOutput("mapPlot")
    )
)))


server = shinyServer(function(input,output){
    
    inFile <- reactive({
        raster::brick(input$layer$datapath)
    })
    
    inShp = reactive({
        readOGR(input$shape$datapath)
    })
    
    output$mapPlot<-renderPlot(
        {
            plot(inFile());
            plot(inShp(), add=TRUE)
        })
})
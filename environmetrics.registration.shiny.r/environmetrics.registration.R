#rm(list = ls())

#wd <- 'C:/Users/gbal/Desktop/github.work/shiny.registration.form/environmetrics.registration.shiny.r'

# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny) # shiny
library(rdrop2) # dropbox

token <- readRDS('token.rds')
drop_acc(dtoken = token)
outputs.dir <- '2017.registration'

fields.to.save <- c('name', 'surname', 'email', 'address')

# define UI ####################################################################################

ui <- fluidPage(
  
  # Details --------------------------------------------------------------------------------------
  
  titlePanel("Details"),
  
  textInput(inputId = "name", label = "Name", value = "", width = '300px'),
  textInput(inputId = "surname", label = "Surname", value = "", width = '300px'),
  textInput(inputId = "email", label = "Email", value = "", width = '300px'),
  textInput(inputId = "address", label = "Address", value = "", width = '100%'),
  
  # presentation ---------------------------------------------------------------------------
  
  titlePanel('Talk or poster'),
  
  helpText("Note: Please uncheck if you would rather do a poster."),
  checkboxInput("talk", "Talk", TRUE),
  textInput(inputId = "title", label = "Title", value = "", width = '100%'),
  textInput(inputId = "keywords", label = "Keywords", value = "", width = '100%'),
  textInput(inputId = "abstract", label = "Abstract", value = "", width = '100%'),
  
  # group preferences ----------------------------------------------------------------------
  
  #titlePanel('Group preferences'),
  
  #helpText("Note: Please rank the groups according to your own preference.",
  #         "Depending on people interests, you may not be given your first choice."),
  #textInput(inputId = "pop", label = "Population dynamics", value = "1", width = '150px'),
  #textInput(inputId = "gis", label = "GIS", value = "2", width = '150px'),
  #textInput(inputId = "design", label = "Survey design", value = "3", width = '150px'),
  
  # groups talks ---------------------------------------------------------------------------
  
  #titlePanel('Group talk'),
  
  #helpText("Note: Please check if you would like to do a long presentation.",
  #         "We assume this is for the group you are most interested in."),
  #checkboxInput("talk.long", "Talk", FALSE),
  #textInput(inputId = "title.long", label = "Title", value = "", width = '100%'),
  #textInput(inputId = "keywords.long", label = "Keywords", value = "", width = '100%'),
  #textInput(inputId = "abstract.long", label = "Abstract", value = "", width = '100%'),
  
  
  # Food section -----------------------------------------------------------------------------
  
  #titlePanel('Food'),
  
  #helpText("Note: Lunch in the canteen will be about 7 euros. We cannot cater for allergies.",
  #         "Dinner will be on Wedneday evening, We will do our best to keep it under 20 euros."),
  
  #checkboxInput("lunch", "Lunch in canteen (7 euros)", FALSE),
  #checkboxInput("vegan", "Vegan", FALSE),
  #checkboxInput("diner", "Diner", FALSE),
  
  # submit --------------------------------------------------------------------------------------
  
  titlePanel('Submission'),
  
  helpText("Note: please check you filled all the parts.",
           "Edits are not possible."),
  actionButton("submit", "Submit", class = "btn-primary")
  
)

# Define server logic required ##############################################################################

server <- function(input, output, session) {
  
  # Whenever a field is filled, aggregate all form data
  formData <- reactive({
    data <- sapply(fields.to.save, function(x) input[[x]])
    data
  })
  
  # When the Submit button is clicked, save the form data
  observeEvent(input$submit, {
    drop_dir(outputs.dir)
    file.name <- paste('registration',#formData[[1]], formData[[2]], 
                  gsub(substring(Sys.time(), 12, 19), pattern = ':', replacement = ''),
                  'RData',
                  sep = '.')
    assign(gsub(file.name, pattern = '.RData', replacement = ''), formData())
    file.dir <- file.path(tempdir(), file.name)
    save(list =  gsub(file.name, pattern = '.RData', replacement = ''), file = file.dir)
    #save(as.list(eval(parse(text = gsub(file.name, pattern = '.RData', replacement = '')))), file = file.dir)
    drop_upload(file.dir, path = '2017.registration')
  })
  
}

# Run the application ########################################################################################
shinyApp(ui = ui, server = server)

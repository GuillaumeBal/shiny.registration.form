#rm(list = ls())

#wd <- 'C:/Users/gbal/Desktop/github.work/shiny.registration.form/environmetrics.registration.shiny.r'

# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

#2019MiTsWorkshop

library(shiny) # shiny
library(shinyjs) # magic button
library(rdrop2) # dropbox

token <- readRDS('token.rds')
drop_acc(dtoken = token)
outputs.dir <- '2019MiJttRegistration/0.applications/'

fields.to.save <- c('name', 'middlename', 'surname', 'email', 'address',
                    'seminar', 'workshp', 'application', 
                    'lunch', 'dinner', 'vegan')

# define UI ####################################################################################

ui <- fluidPage(
  
  useShinyjs(),
  
  # Details --------------------------------------------------------------------------------------
  
  helpText("WARNING: PLEASE LIMIT SPECIAL CHARACTERS TO . , ; @ ( ) _"),
  helpText(""),
  
  titlePanel("Details"),
  
  textInput(inputId = "name", label = "Name", value = "", width = '300px'),
  textInput(inputId = "middlename", label = "Middle name", value = "", width = '300px'),
  textInput(inputId = "surname", label = "Surname", value = "", width = '300px'),
  textInput(inputId = "email", label = "Email", value = "", width = '300px'),
  textInput(inputId = "address", label = "Address", value = "", width = '100%'),
  
  # Attending -----------------------------------------------------------------------------
  
  titlePanel('Attending'),
  
  checkboxInput("seminar", "Seminar on wedesday", FALSE),
  checkboxInput("workshop", "Workshop on Thursday/Friday", FALSE),
  textAreaInput(inputId = "application", label = "Application", height = '50px',width = '600px',  resize = 'both',
                placeholder = 'Please explain briefy how you would benefit from the workshop and whether you would dissemate its content to your workplace colleagues'),


  # Food section -----------------------------------------------------------------------------
  
  titlePanel('Food / Social'),
  
  helpText("Lunch in the canteen is about 7 euros.", "Dinner will be on Thursday evening.",
           'The canteen cannot cater for allergies.'),
  checkboxInput("lunch", "Lunch in canteen", FALSE),
  checkboxInput("dinner", "Dinner", FALSE),
  checkboxInput("vegan", "I am vegan", FALSE),
  
  # submit --------------------------------------------------------------------------------------
  
  titlePanel('Submission'),
  
  helpText("Please check you filled all the parts."),
  actionButton("submit", "Submit", class = "btn-primary"),
  helpText("")
  
)

# Define server logic required ##############################################################################

server <- function(input, output, session) {
  
  # Whenever a field is filled, aggregate all form data
  formData <- reactive({
    data <- sapply(fields.to.save, function(x) input[[x]])
    data
  })
  
  # Information about button being clicked
  observe({ 
    if(input$submit == 1){
      info('Thanks for registering !')
    } 
    if(input$submit > 1){
      info('Registration updated !')
    }
  })
  
  output$nText <- renderText({
    input$submit
  })
  
  # When the Submit button is clicked, save the form data
  observeEvent(input$submit, {
    drop_dir(outputs.dir)
    file.name <- paste(#'registration', 
      input$name, input$surname,
      gsub(substring(Sys.time(), 12, 19), pattern = ':', replacement = '.'),
      'RData',
      sep = '.')
    assign(gsub(file.name, pattern = '.RData', replacement = ''), formData())
    file.dir <- file.path(tempdir(), file.name)
    save(list = gsub(file.name, pattern = '.RData', replacement = ''), file = file.dir)
    #save(as.list(eval(parse(text = gsub(file.name, pattern = '.RData', replacement = '')))), file = file.dir)
    drop_upload(file.dir, path = outputs.dir)
  })
  
}

# Run the application ########################################################################################
shinyApp(ui = ui, server = server)
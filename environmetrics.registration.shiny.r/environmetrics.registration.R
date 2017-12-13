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
library(shinyjs) # magic button
library(rdrop2) # dropbox

token <- readRDS('token.rds')
drop_acc(dtoken = token)
outputs.dir <- '2017.registration'

fields.to.save <- c('name', 'surname', 'email', 'address',
                    'type',  'authors', 'title', 'keywords', 'abstract',
                    'pop', 'life', 'management', 'env', 'gis', 'design',
                    'title.long', 'authors.long', 'abstract.long', 'keywords.long', #'talk.long', 
                    'lunch', 'vegan', 'diner')

# define UI ####################################################################################

ui <- fluidPage(
  
  useShinyjs(),
  
  # Details --------------------------------------------------------------------------------------
  
  helpText("WARNING: PLEASE DO NOT USE SPECIAL CHARACTERS APART FROM . , ; @ ( ) _"),
  helpText(""),
  
  titlePanel("Details"),
  
  textInput(inputId = "name", label = "Name", value = "", width = '300px'),
  textInput(inputId = "surname", label = "Surname", value = "", width = '300px'),
  textInput(inputId = "email", label = "Email", value = "", width = '300px'),
  textInput(inputId = "address", label = "Address", value = "", width = '100%'),
  
  # presentation ---------------------------------------------------------------------------
  
  titlePanel('Talk / poster'),
  
  helpText("On the first day there will be quick-fire presentations (10 min) and posters on any subject concerning environmental statistics and modelling of natural resources.",
           "If you would like to present, provide details below."),
  
  radioButtons(inputId = 'type', 'Presentation type', choices = c('Talk', 'Poster', 'None')),
  textInput(inputId = "title", label = "Title", value = "", width = '100%'),
  textAreaInput(inputId = 'authors', 'Authors list', height = '50px', width = '100%', resize = 'both',
                placeholder = 'One author per line with email and affiliation'), 
  textAreaInput(inputId = "abstract", label = "Abstract", height = '50px', width = '100%',  resize = 'both',
                placeholder = 'Please limit to 300 words'),
  textInput(inputId = "keywords", label = "Keywords", value = "", width = '100%',
            placeholder = 'Please limit to 6 and separate with comma'),
  
  
  # group preferences ----------------------------------------------------------------------
  
  titlePanel('Groups of preference'),
  
  helpText("On the second day we will break out into subgroups, please rank your preferred subjects for these groups below. Depending on people interests, you may not be given your first choice."),
  
  textInput(inputId = "pop", label = "Population dynamics", value = "1", width = '200px'),
  textInput(inputId = "life", label = "Life history trait / Evolution / genetics", value = "2", width = '200px'),
  textInput(inputId = "management", label = "Management advice", value = "3", width = '200px'),
  textInput(inputId = "env", label = "Environmental change / modelling", value = "4", width = '200px'),
  textInput(inputId = "gis", label = "GIS", value = "5", width = '200px'),
  textInput(inputId = "design", label = "Survey design", value = "6", width = '200px'),

  # groups talks ---------------------------------------------------------------------------
  
  titlePanel('Group talk'),
  
  helpText("Please fill if you would like to do a longer, more detailed presentation in one of the sub-groups.",
           "We assume this is for the group you have ranked as number 1."),
  
  #checkboxInput("talk.long", "Talk", FALSE),
  textInput(inputId = "title.long", label = "Title", value = "", width = '100%'),
  textAreaInput(inputId = 'authors.long', 'Authors list', height = '50px', width = '100%', resize = 'both',
                placeholder = 'One author per line with email and affiliation'), 
  textAreaInput(inputId = "abstract.long", label = "Abstract", height = '50px', width = '100%',  resize = 'both',
                placeholder = 'Please limit to 300 words'),
  textInput(inputId = "keywords.long", label = "Keywords", value = "", width = '100%',
            placeholder = 'Please limit to 6 and separate with comma'),
  
  
  # Food section -----------------------------------------------------------------------------
  
  titlePanel('Food / Social'),
  
  helpText("Lunch in the canteen will be about 7 euros.",
           "Dinner will be on Wedneday evening, we will do our best to keep it under 20 euros.",
           'We cannot cater for allergies but you can choose a vegan option for all your meals.'),
  checkboxInput("lunch", "Lunch in canteen", FALSE),
  checkboxInput("dinner", "Diner", FALSE),
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
    drop_upload(file.dir, path = '2017.registration')
  })
  
}

# Run the application ########################################################################################
shinyApp(ui = ui, server = server)
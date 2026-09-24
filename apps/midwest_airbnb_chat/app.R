# ISA 401 Midwest Airbnb Chat: ask questions, get SQL, a table, or a chart back
library(shiny)
library(bslib)
library(querychat)

con = DBI::dbConnect(RSQLite::SQLite(), "data/midwest_airbnb.db")

client = ellmer::chat_openai(
  model  = "gpt-5.6-luna",
  params = ellmer::params(reasoning_effort = "none")
)

qc = querychat(
  con, "listings",
  client             = client,
  tools              = c("filter", "query", "visualize"),  # visualize: charts in the chat (needs ggsql)
  data_description   = "data/data_desc.md",
  extra_instructions = "data/extra_instructions.md",
  greeting = "Ask me about the 14,887 Airbnb listings in Chicago, Columbus, and the Twin Cities."
)

theme = bs_theme(
  version   = 5,
  bootswatch = "flatly",
  primary   = "#1F4E79",  # lake blue
  secondary = "#C8553D",  # brick red
  success   = "#588157"   # prairie green
)

ui = page_navbar(
  title = "Midwest Airbnb Explorer",
  theme = theme,
  nav_panel(
    "Explorer",
    layout_sidebar(
      sidebar = qc$sidebar(),
      card(
        full_screen = TRUE,
        card_header(textOutput("table_title", inline = TRUE)),
        DT::DTOutput("table")
      )
    )
  )
)

server = function(input, output, session) {
  qc_vals = qc$server()

  output$table_title = renderText(qc_vals$title() %||% "All listings")

  output$table = DT::renderDT(
    DT::datatable(qc_vals$df(), options = list(scrollX = TRUE, pageLength = 10))
  )
}

shinyApp(ui, server)

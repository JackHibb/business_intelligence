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
  ),
  nav_panel(
    "About",
    card(
      card_header("About this app"),
      markdown("
Ask a question in plain English about Airbnb listings in three Midwest markets.
An LLM turns the question into SQL, runs it against a SQLite database, and
shows the query so you can check the logic.

**Data.** The `listings` table in `data/midwest_airbnb.db`: 14,887 listings and
29 columns from [Inside Airbnb](https://insideairbnb.com/get-the-data/):

| Market | Listings | Snapshot |
|---|---|---|
| Chicago | 7,439 | 2026-07-20 |
| Twin Cities (Minneapolis-St. Paul metro) | 4,861 | 2026-07-21 |
| Columbus | 2,587 | 2026-07-23 |

Only listings that showed a nightly price on the snapshot date are included.
The full data dictionary is in `data/data_desc.md`.

**Try asking:**

- What is the median nightly price by city?
- Which ten Chicago neighbourhoods have the most listings?
- Show superhost listings in Columbus that sleep six or more.

**How it works.** The chat uses [querychat](https://github.com/posit-dev/querychat)
and [ellmer](https://ellmer.tidyverse.org/) with OpenAI's `gpt-5.6-luna`.
Filtering the dashboard updates the table on the Explorer tab. LLM answers can
be wrong, so check the SQL before you trust a number.

**Course.** Built for ISA 401 at Miami University.
      ")
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

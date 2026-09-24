# ISA 401 Midwest Airbnb Chat: ask questions, get SQL, a table, or a chart back
library(shiny)
library(bslib)

con = DBI::dbConnect(RSQLite::SQLite(), "data/midwest_airbnb.db")

client = ellmer::chat_openai(
  model  = "gpt-5.6-luna",
  params = ellmer::params(reasoning_effort = "none")
)

qc = querychat::querychat(
  con, "listings",
  client             = client,
  tools              = c("filter", "query", "visualize"),
  greeting           = "Ask me about 14,887 Airbnb listings in Chicago, Columbus, and the Twin Cities.",
  data_description   = "data/data_desc.md",
  extra_instructions = "data/extra_instructions.md"
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
        fill = FALSE,
        card_header("SQL behind the current view"),
        verbatimTextOutput("sql")
      ),
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
**Built by Jack Hibbard** for ISA 401 at Miami University.

Ask a question in plain English about Airbnb listings in three Midwest cities.
An LLM turns the question into SQL, runs it against a SQLite database, and
shows the SQL above the table on the Explorer tab so you can check the logic.

**Data source.** The listings come from [Inside Airbnb](https://insideairbnb.com/get-the-data/),
which publishes snapshots of public Airbnb listings. This app uses the `listings`
table in `data/midwest_airbnb.db`: 14,887 listings and 29 columns from three snapshots:

| City | Listings | Snapshot date |
|---|---|---|
| Chicago | 7,439 | 2026-07-20 |
| Columbus | 2,587 | 2026-07-23 |
| Twin Cities (Minneapolis-St. Paul metro) | 4,861 | 2026-07-21 |

Only listings that showed a nightly price on the snapshot date are included.
The full data dictionary is in `data/data_desc.md`.

**Try asking:**

- Which Columbus neighbourhood has the priciest entire homes?
- Do superhosts charge more per night than other hosts? Show it as a bar chart.
- How many listings could host a party of ten?

**How it works.** The chat uses [querychat](https://github.com/posit-dev/querychat)
and [ellmer](https://ellmer.tidyverse.org/) with OpenAI's `gpt-5.6-luna`. LLM
answers can be wrong, so check the SQL before you trust a number.
      ")
    )
  )
)

server = function(input, output, session) {
  qc_vals = qc$server()

  output$sql = renderText({
    sql = qc_vals$sql()
    if (is.null(sql) || !nzchar(sql)) {
      "-- No filter applied yet; showing every row\nSELECT * FROM listings"
    } else {
      sql
    }
  })

  output$table_title = renderText(qc_vals$title() %||% "All listings")

  output$table = DT::renderDT(
    DT::datatable(qc_vals$df(), options = list(scrollX = TRUE, pageLength = 10))
  )
}

shinyApp(ui, server)

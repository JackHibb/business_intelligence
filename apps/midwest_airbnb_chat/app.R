# ISA 401 Midwest Airbnb Chat: ask questions, get SQL, a table, or a chart back
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

qc$app_obj()

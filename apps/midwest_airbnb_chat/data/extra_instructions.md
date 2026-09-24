# Extra Instructions

Rules the LLM follows when it writes SQL for `listings`.

- `price` is the nightly price in U.S. dollars. When the user asks what something costs, use `price` and round money to whole dollars in the answer.
- `city` has exactly three values: `'Chicago'`, `'Columbus'`, and `'Twin Cities'`. Map what the user types to one of them: "Minneapolis", "St. Paul", "Saint Paul", "MSP", or "Minnesota" means `city = 'Twin Cities'`, "Chicago" or "Illinois" means `city = 'Chicago'`, and "Columbus" or "Ohio" means `city = 'Columbus'`. For any other place name, search `neighbourhood` case-insensitively with `LOWER(neighbourhood) LIKE '%...%'` before saying it is not in the data. Twin Cities neighbourhoods are counties, so treat Minneapolis as roughly `neighbourhood = 'Hennepin'` and St. Paul as roughly `neighbourhood = 'Ramsey'`, and tell the user the match is approximate.
- `host_is_superhost` is the text `'t'` or `'f'`, not a boolean, so filter with `host_is_superhost = 't'`, never `= 1` or `= TRUE`. `instant_bookable` and `host_since` are `NULL` in every row. If a question depends on either one, tell the user the data is not available instead of running a query that returns nothing.
- When averaging or ranking by `review_scores_rating` or `reviews_per_month`, leave out rows where the column is `NULL` (listings with no reviews) and never treat `NULL` as 0. Report how many listings the figure is based on, and when ranking listings by rating, require `number_of_reviews >= 5` so a single five-star review does not top the list.

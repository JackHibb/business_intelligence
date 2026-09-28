# Airbnb Market Analysis with dplyr (Assignment 06)

Eight dplyr analyses of Inside Airbnb listings for Chicago, Columbus, and the Twin Cities (July 2026 snapshots), with monthly availability for the year ahead and monthly reviews for the two years behind. Code: `airbnb_analysis.Rmd`; knitted output: `airbnb_analysis.html`; data: `../data/midwest_airbnb_extended.db`.

## Five findings

- Hosts with ten or more listings hold 37 percent of Columbus's listings and 32 percent of Chicago's, but only 17 percent of the Twin Cities', so Columbus is the most professionally run of the three markets.
- The top 10 percent of listings earn 41 percent of Chicago's estimated revenue and 40 percent of the Twin Cities', compared with 36 percent in Columbus, so a small group of listings takes a large share of guest spending in every city.
- Twin Cities demand peaked in August 2025 at 7,399 reviews, 2.37 times its February 2026 low of 3,119, so a Twin Cities host should plan for winter demand at less than half of summer demand.
- Superhost entire homes charge a median $44 more per night than other hosts' in Chicago and $41 more in Columbus, but $1 less in the Twin Cities, so the badge comes with higher prices in two of the three markets only.
- For October 2026, 19 percent of Columbus entire homes already have fewer than half their nights open, against 22 percent in Chicago, so Columbus hosts have the most open fall inventory left to fill (a closed night could be booked or blocked by the host).

## What the join lost

456 listings have no rows in the availability table, so any analysis that joins listings to availability silently drops them. Chicago loses the most (267), followed by the Twin Cities (120) and Columbus (69).

## Caveats

- A night that is not available is either booked or blocked by the host; the data cannot tell which.
- Monthly reviews stand in for completed stays, so they measure demand, not bookings.
- The only nightly price is the snapshot `price` in `listings`; the 2026 calendar carries no prices.

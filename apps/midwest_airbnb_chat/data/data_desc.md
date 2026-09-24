# Midwest Airbnb Listings: Data Dictionary

**Dataset:** `listings` table in `midwest_airbnb.db` (SQLite), 14,887 rows and 29 columns
**Source:** Inside Airbnb (https://insideairbnb.com/get-the-data/), the detailed `listings.csv.gz` file for each of three regions: Chicago (snapshot 2026-07-20), Columbus (snapshot 2026-07-23), and Twin Cities MSA (snapshot 2026-07-21). Column meanings follow Inside Airbnb's data dictionary and assumptions (https://insideairbnb.com/data-assumptions/).
**Course:** ISA 401, Miami University

> One row is one listing that showed a nightly price on the snapshot date; listings with no price were dropped. Empty cells are stored as SQL `NULL`. Dates are ISO `YYYY-MM-DD` text strings, not SQLite dates, so compare them as strings or wrap them in `date()`.

---

## Field Definitions

| Field | Type | Description |
|---|---|---|
| `city` | text | Which Inside Airbnb region the listing came from: `Chicago` (7,439 rows), `Columbus` (2,587), or `Twin Cities` (4,861). The Twin Cities file covers the Minneapolis-St. Paul metro area, not just the two cities. |
| `snapshot_date` | text | Date Inside Airbnb compiled the file, stored as an ISO text string, not a date: `2026-07-20` for Chicago, `2026-07-23` for Columbus, `2026-07-21` for Twin Cities. Every row of a city shares the same value. |
| `id` | text | Airbnb's listing id. Unique across the table (14,887 distinct values). Stored as text even though it looks numeric, so compare it to a quoted string. |
| `name` | text | Listing title as shown on Airbnb (for example "Tiny Studio Apartment 94 Walk Score"). Never empty. |
| `host_id` | text | Airbnb's id for the host account. 6,970 distinct hosts; one host can have many listings (the largest has 104). Stored as text like `id`, so compare it to a quoted string. Use `host_id`, not `host_name`, to count or group hosts. |
| `host_name` | text | Host's display name, usually a first name or a company name (for example "Rebecca", "Evolve"). Not unique: different hosts share names, and "Evolve" appears under more than one `host_id`. `NULL` for 25 rows. |
| `host_since` | text | Date the host joined Airbnb. **`NULL` for every row** in this extract, so it cannot be used to measure host tenure. |
| `host_is_superhost` | text | Whether the host has Airbnb Superhost status: the text `'t'` (7,982 rows) or `'f'` (6,880), not a boolean. `NULL` for the same 25 rows where `host_name` is `NULL`. |
| `neighbourhood` | text | Inside Airbnb's `neighbourhood_cleansed` column: the area the listing falls in, found by placing its latitude and longitude on a public boundary file. The unit differs by city. Chicago uses its 77 community areas (for example "Near North Side", "West Town"), Columbus uses 26 planning areas (for example "Near North/University"), and Twin Cities uses 16 **counties** (for example "Hennepin", "Ramsey"). Never `NULL`. |
| `latitude` | real | Latitude in decimal degrees (WGS84). Airbnb shifts the map location up to about 150 m to protect hosts, so treat it as approximate. Range 39.88 (Columbus) to 46.24 (northern Twin Cities MSA). |
| `longitude` | real | Longitude in decimal degrees (WGS84), negative because the listings are west of Greenwich. Shifted like `latitude`. Range -94.53 to -82.78. |
| `property_type` | text | Property type the host picked on Airbnb, more detailed than `room_type` (62 distinct values). The most common are `Entire rental unit` (5,581), `Entire home` (3,805), `Private room in home` (1,441), `Entire condo` (780), `Private room in rental unit` (716), and `Room in hotel` (557). Never `NULL`. |
| `room_type` | text | Airbnb's four listing categories: `Entire home/apt` (11,652 rows), `Private room` (2,951), `Hotel room` (246), or `Shared room` (38). |
| `accommodates` | integer | Maximum number of guests the listing sleeps, from 1 to 16 (mean 5.0; 2 is the most common value). Never `NULL`. |
| `bedrooms` | real | Number of bedrooms, from 1 to 16. Stored as a real (for example `2.0`). `NULL` for 2,976 rows, mostly private, hotel, and shared rooms plus some studios, so `NULL` usually means "not reported", not zero. |
| `beds` | real | Number of beds, from 1 to 32. Stored as a real. `NULL` for 668 rows. |
| `bathrooms_text` | text | Bathrooms as the text Airbnb shows, for example `1 bath`, `1.5 baths`, `1 shared bath`, `1 private bath`, or `Shared half-bath` (32 distinct values). The word "shared" (1,759 rows) means guests share the bathroom. There is no numeric bathrooms column, so parse the leading number if you need a count. `NULL` for 71 rows. |
| `price` | real | Nightly price in U.S. dollars on the snapshot date, with the dollar sign and commas removed. Ranges from 2.56 to 11,412; never `NULL` (rows without a price were dropped). |
| `minimum_nights` | integer | Minimum number of nights a guest must book, from 1 to 365. 3,077 listings require 30 or more nights, which makes them monthly rentals rather than short stays. `NULL` for 15 rows. |
| `availability_365` | integer | Number of nights the listing is open to book in the 365 days after the snapshot, from 0 to 365. A night can be unavailable because it is booked or because the host blocked it, so a low value does not always mean high demand. 18 listings show 0. |
| `number_of_reviews` | integer | Total reviews the listing has received, from 0 to 2,246. 1,761 listings have no reviews. |
| `number_of_reviews_ltm` | integer | Reviews received in the last twelve months ("ltm") before the snapshot, from 0 to 1,220. Never larger than `number_of_reviews`. |
| `first_review` | text | Date of the listing's first review as ISO text, from `2009-07-03` to `2026-07-20`. `NULL` for the 1,761 listings with no reviews. |
| `last_review` | text | Date of the most recent review as ISO text, from `2014-08-23` to `2026-07-22`. `NULL` for the 1,761 listings with no reviews. |
| `review_scores_rating` | real | Average overall guest rating on a 1-to-5 scale (mean 4.80, so scores cluster near the top). `NULL` for the 1,761 listings with no reviews. |
| `reviews_per_month` | real | Inside Airbnb's average reviews per month over the listing's life, from 0.01 to 77.72. `NULL` for the 1,761 listings with no reviews (no reviews means no rate, not a rate of 0). |
| `instant_bookable` | text | Whether a guest can book without waiting for host approval. Inside Airbnb codes it as `'t'` or `'f'`, but **it is `NULL` for every row** in this extract, so it cannot be used to filter or compare listings. |
| `estimated_revenue_l365d` | real | Inside Airbnb's estimate of the listing's revenue in U.S. dollars over the last 365 days: price times an estimated number of booked nights, where booked nights are modelled from review activity. It is a model estimate, not actual earnings. Ranges from 0 (2,907 listings) to 1,114,800; median about 15,750. Never `NULL`. |
| `amenities_count` | integer | Not an Inside Airbnb column. It was computed for this course as the number of items in each listing's `amenities` list (Wi-Fi, kitchen, parking, and so on). Ranges from 0 to 100, median 45. The amenities themselves are not in the table. Never `NULL`. |

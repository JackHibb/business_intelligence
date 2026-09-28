# Midwest Airbnb Extended: Data Dictionary

**Dataset:** `midwest_airbnb_extended.db` (SQLite), three tables
**Source:** Inside Airbnb (https://insideairbnb.com/get-the-data/): listings and calendar files for Chicago (snapshot 2026-07-20), Columbus (2026-07-23), and the Twin Cities MSA (2026-07-21)
**Course:** ISA 401, Miami University

| Table | One row is | Rows | Columns |
|---|---|---|---|
| `listings` | one listing | 14,887 | 29 (same table as Assignment 05) |
| `availability_monthly` | one listing in one calendar month, 2026-07 to 2027-06 | 158,741 | 4 |
| `reviews_monthly` | one listing in one month with at least one review, 2024-07 to 2026-06 | 142,388 | 3 |

## `availability_monthly`

| Field | Type | Description |
|---|---|---|
| `id` | text | Listing id; joins to `listings.id`. 14,431 distinct listings (456 listings have no rows). |
| `month` | text | Calendar month as `"YYYY-MM"` text (for example `"2026-10"`). |
| `nights_in_month` | integer | Nights of that month covered by the listing's calendar. |
| `nights_available` | integer | Nights open for booking. A night that is not available is either booked or blocked by the host; the data cannot tell which. |

Primary key: (`id`, `month`). The calendar carries no nightly prices; the only price is `listings.price`.

## `reviews_monthly`

| Field | Type | Description |
|---|---|---|
| `id` | text | Listing id; joins to `listings.id`. 12,156 distinct listings. |
| `month` | text | Month the reviews were posted, `"YYYY-MM"` text. |
| `reviews` | integer | Number of reviews that month (at least 1; months with none have no row). |

Primary key: (`id`, `month`). Inside Airbnb uses reviews as a stand-in for completed stays, so monthly reviews measure demand, not bookings.

## `listings`

See `data_desc.md` from Assignment 05 for all 29 columns.

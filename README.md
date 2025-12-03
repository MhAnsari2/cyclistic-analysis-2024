


# **Cyclistic Bike-Share Data Analysis**
Google Data Analytics Capstone project using SQL and Tableau

---

## 1. Introduction

The duties of a junior data analyst at the fictional Chicago-based bike-sharing business **Cyclistic** are replicated in this case study.  
I use the full **six-step data analysis framework** to address the company's key business questions:

**Ask  → Prepare → Process → Analyze → Share →  Act**

Finding out **how annual members and casual riders differ in their usage patterns** and turning these findings into **data-driven marketing recommendations** are the main goals here.

---

##  Quick Access

- **Data Source:** 
 *[Public historical trip data (2024 divvy trip data)](https://divvy-tripdata.s3.amazonaws.com/index.html)* 
  *[Accessed: 2025-08-01]*

- **Tableau Visualizations:**  
  *[Tableau Visualization](https://public.tableau.com/views/TheCyclisticBike-ShareDataAnalysis/PopularRoutes?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)*

- **SQL Scripts:**  
  - 01 – Data Combining  
  - 02 – Data Exploration  
  - 03 – Data Cleaning  
  - 04 – Data Analysis  

---

##  2. Background: About Cyclistic

Cyclistic is a sizable bike-sharing program located in Chicago that offers:  
- **5,800+ bicycles**  
- **600+ docking stations**  
- Specialized bikes such as:
  - *Reclining bikes*  
  - *Hand tricycles*  
  - *Cargo bikes*

For riders with disabilities or others who are unable to utilize regular bikes, these inclusive choices increase accessibility. **92%** of consumers still favor traditional two-wheel options despite the availability of modern alternatives.

Usage patterns:
- Most riders use Cyclistic for **leisure**
- About **30%** use the service for **daily commute**

Cyclistic’s pricing model includes:
- **Single-ride passes**
- **Full-day passes**
- **Annual memberships**

Riders who purchase single ride and full-day passes  = **Casual Riders**  
Riders with annual plans = **Members**

Cyclistic’s finance team noted that **Long-term revenue from annual members is substantially higher.**
Therefore, the strategic priority is to **convert more casual riders into members**.

---

## 3. The Business Problem

Long-term growth, according to **Moreno**, director of marketing, depends on raising the number of annual members. Casual riders are perfect targets for targeted marketing since they are already familiar with Cyclistic and utilize the service.  

The company needs precise responses before creating campaigns:

1. **What behavioral differences exist between annual members and casual riders?**  
2. **What could persuade casual riders to convert, and what drives them?**  
3. **How can digital marketing be optimized to successfully reach the appropriate audience?**

Factual insights supported by clean data and strong visualization are necessary for executive approval.

---

##  4. Scenario

I take on the role of a **junior data analyst** on the Cyclistic marketing analytics team.  
My responsibility is to:

- Work with historical trip data  
- Clean, prepare, and analyze the datasets  
- Create visualizations  
- Communicate findings  
- Support strategic recommendations aimed at converting casual riders into annual members

This document summarizes the first part of the project—including problem framing, context, and preparation for the analytical workflow.

---

## 5. Ask – Key Questions and Business Tasks

### 5.1 Business Task

By converting more casual riders into annual members, Cyclistic hopes to boost long-term earnings.  
My job is to:

> Determine how annual members and casual riders use Cyclistic bikes differently using trip data from the past. This information can be used to build a focused marketing campaign that aims to convert casual riders into members.

Instead than focusing on operational or pricing changes, the analysis focuses on rider behavior.

### 5.2 Key Questions

The analysis provides answers to three key questions in order to help this business task:
1. **Usage patterns**  
   -What are the differences between annual members and casual riders in terms of:
     - number of trips  
     - ride length  
     - time of day, day of week, and month/season  
     - bike type usage (classic vs electric)?

2. **Context of use**  
   - When and where do casual riders often ride as opposed to members?  
   - Do casual cyclists particularly like any particular routes or locations?
   

3. **Implications for marketing**  
   - What kinds of advertising efforts and messaging might persuade casual passengers to join based on these distinctions? 
    - Which rider behaviors ought to be given priority?

### 5.3 Stakeholders

- **Moreno** – Marketing director and principal decision-maker
- **Team for Cyclistic Marketing Analytics** – uses the findings to design campaigns  
- **Cyclistic Executives** – must have solid, data-driven proof before authorizing marketing expenditures.

- ---

## 6. Prepare – Data Source and Structure

### 6.1 Data Source

Divvy/Cyclistic's **public historical trip data** is the source of all the information used in this project.

- **Source:** [Divvy / Cyclistic historical trip data (2024)](https://divvy-tripdata.s3.amazonaws.com/index.html)  
- **Access date:** 2025-08-01  
- **Owner:** Data made available by Motivate International Inc. (Divvy); Cyclistic is a fictional company built on this real-world data.
The information has already been de-identified. There is no personally identifiable information (PII) such as phone numbers, names, or payment information.

Monthly CSV files containing the raw data are supplied. In order to capture a full year of behavior and seasonality, I used **12 months of data (January–December 2024)** for this analysis.

### 6.2 Files and Storage

Each CSV data file has a similar naming scheme, such as:
202401-divvy-tripdata.csv … 202412-divvy-tripdata.csv

For this project, I first downloaded the CSV data files for 2024 from the public Divvy/Cyclistic data portal.  
These files were then loaded into BigQuery, where I used a set of SQL scripts (01_combine, 02_explore, 03_clean, 04_analyze) to:

- combined all months into a single table,
- explored data quality and structure,
- cleaned and filtered the records, and
- created summary tables for analysis.

The final cleaned table (`cleaned_combined_data`) was then connected directly to Tableau for building the dashboards.  
All related SQL scripts are included in this repository.

### 6.3 Main Fields Used

There are numerous columns in every monthly file. The following key areas are the focus of the analysis:

- `ride_id` – unique trip identifier  
- `rideable_type` – bike type (`classic_bike`, `electric_bike`, etc.)  
- `started_at` – start date and time of the ride  
- `ended_at` – end date and time of the ride  
- `start_station_name`, `end_station_name` – station names  
- `start_lat`, `start_lng`, `end_lat`, `end_lng` – geographic coordinates  
- `member_casual` – rider category (`member` vs `casual`)

Later in the **Process** step, more subset fields are generated from these columns. including:

- `ride_length` (in minutes)  
- `day_of_week`  
- `month`  

### 6.4 Coverage and Range

Geographically, the Divvy system covers Chicago and the surrounding service area.  
- **Time frame:** Full calendar year 2024 (12 consecutive months)  
- **Unit of analysis:** Individual bike trip

The analysis can compare **seasonal patterns** and observe how behavior varies between weekdays, weekends, and different months by using a full year's worth of data.

### 6.5 Data Limitations and Premises

There are several important limitations:

- **No demographic information** – Age, gender, income, and home location are not taken into account; the analysis is solely focused on travel habits.  
- **Station changes over time** – Routes are interpreted as they appear in the data; some stations may be added or removed during the year.  
- **Data quality issues** – A tiny percentage of records have clearly inaccurate timestamps (such as negative or exceptionally long ride durations) or lack station names or coordinates. These are handled in the cleaning step and excluded from the final analysis.  
- **member_casual label** – The analysis is predicated on the system assigning the `member_casual`⁣ field correctly.

When interpreting the findings and developing recommendations, all of these limitations are taken into consideration.

---

## 7. Process – Cleaning and Transforming (SQL)

Every process was carried out using SQL (BigQuery-style syntax). Four scripts that are kept in the SQL⁣ folder make up the workflow.

### 7.1 Tools 

BigQuery SQL was used for data processing. The input was the 12 monthly CSV data files for 2024, and the result was a single cleaned table called cleaned_combined_data.
Later on the output from previous step is used as an input to visialize the results by utilizing the web based Tableau software. And finally, Github is where the final project is shared through.

### 7.2 Data Combining 

- Entire 12 monthly tables were imported.  
- Used `UNION ALL` to stack them into one table.  
- Retained only the relevant columns: IDs, timestamps, stations, coordinates, bike type, and `member_casual`.

### 7.3 Data Cleaning 

Key cleaning steps taken:

- Removed rows with:
  - missing `ended_at`  
  - missing `member_casual`  
  - missing start or end coordinates
- Calculated ride duration (minutes):  
  `ride_length = TIMESTAMP_DIFF(ended_at, started_at, MINUTE)`
- Filtered out trips with:
  - `ride_length <= 0` (invalid)  
  - `ride_length > 1440` (over 24 hours, treated as outliers)

---

## 8. Analyze – Exploring Member vs Casual Behaviour

### 8.1 Approach

After creating `cleaned_combined_data`, I moved from raw trips to patterns using:

- **SQL (`04_analyze.sql`)** – commute vs leisure splits, weekday vs weekend balance, duration summaries, long-ride shares, bike-type usage, and top routes by membership.
- **Tableau** – visual comparisons of members vs casual riders across time, duration, and location.

---

### 8.2 Commute vs Leisure and Weekends

In SQL I:

- Tagged each trip as **commute** (weekdays 07–09 and 16–19) or **leisure** (everything else).
- Calculated, by `member_casual`:
  - `commute_trips`, `leisure_trips`
  - `weekend_trips`, `weekday_trips`
  - `weekend_index = weekend_trips / weekday_trips`

These show that members take a larger share of trips in commute windows and rely less on weekends, while casual riders lean relatively more on weekends and off-peak times. Tableau then visualises this by hour of day and day type.

---

### 8.3 Ride Duration and Long Trips

For each membership type, SQL computes:

- **Median ride length** and **90th percentile** (to avoid averages being skewed by outliers).
- Monthly **long-ride share** (> 30 minutes): `long_share = long_trips / total_trips`.

The results show that casual riders typically ride longer and have a higher proportion of long trips. In Tableau, these appear as side-by-side bars and lines for members vs casual riders.

---

### 8.4 Bike Types and Routes

To understand how and where people ride, SQL:

- Groups trips by `member_casual`, `rideable_type`, and `time_bucket` (`commute` vs `leisure`) to compare classic vs electric bike usage.
- Finds the top repeated `start_station_name → end_station_name` pairs for each membership type (top 10 routes).

These outputs are visualised in Tableau as:

- A bar chart of the most common routes.
- A map connecting the main origin–destination pairs.

Together, the SQL aggregations and Tableau dashboards reveal clear behavioural differences between members and casual riders, which are summarised in the findings and used in the recommendations that follow.

---

## 9. Share – Dashboards and Visual Story

To present the results, I published an interactive Tableau workbook that connects directly to the cleaned 2024 data. Instead of a single dense view, the story is split into three screens that build on one another and mirror the main business questions.

The first screen is an overview of members versus casual riders. It brings together total trip counts, typical ride length (both median and average), and the split between classic and electric bikes. At a glance, it shows who rides more often, how long their trips usually last, and whether there are any clear differences in preferred bike types. This gives decision-makers a quick, intuitive sense of the two groups before diving into more detail.

The second screen turns to time. Here, usage is broken down by hour of day, day of week, and broad season, always with members and casual riders shown side by side. Morning and late-afternoon peaks for members, stronger weekend and summer patterns for casual riders, and general seasonal trends become immediately visible. This view is designed to support questions like “when should we advertise?” or “which periods look most leisure-oriented versus commute-oriented?”

The final screen focuses on place. It lists the most frequent start–end station pairs for each rider type and draws the main routes on a map using the station coordinates. This reveals corridors and clusters where the system is used heavily, including routes that are particularly popular among casual riders. These locations are natural candidates for station-level signage, local partnerships, or geographically targeted digital campaigns.

Together, these three views turn the SQL summaries into a coherent visual narrative: how much people ride, when they ride, and where they go, always comparing members and casual riders in a way that directly supports the marketing question behind the case study.


---

## 10. Findings – How Members and Casual Riders Differ

### 10.1 Total Usage

Across the full year, **members ride more often** than casual riders.
The number of member trips exceeds the number of casual trips in every month of 2024. Members are therefore the core of everyday usage, with casual riders forming a smaller but still important share.

### 10.2 Trip Duration

Ride length patterns are almost the reverse of the volume patterns.

Casual riders have **higher median** and **higher 90th percentile** ride-lengths than members. The **share of long trips** (over 30 minutes) is also consistently higher for casual riders.

Members tend to take shorter, frequent trips that look practical and routine; casual riders are more likely to turn a ride into a longer outing.

### 10.3 Time and Seasonality

Time-of-day, weekday/weekend, and seasonal tendencies accentuate this variance in how the service is used.

- Members show clear peaks on **weekday mornings and late afternoons**, matching typical commute times.
- Their **weekend index** (weekend trips ÷ weekday trips) is lower, meaning a larger share of their riding happens on weekdays.
- Casual riders have a **higher weekend index** and more activity in off-peak and leisure-friendly periods.

Both groups ride more in the spring and summer than in the winter, although casual usage reduces more sharply in the cold months, while members continue to ride more frequently.

### 10.4 Bike Types

Bike choice is relatively balanced.

- Both groups use **classic bikes** for the majority of trips.
- Electric bikes make a **significant but secondary** part of trips for each group.

Classic bikes continue to be the norm, with electric bikes serving as a shared convenience alternative; there is no significant change where one group depends nearly entirely on e-bikes.

### 10.5 Routes and Locations

Different centers of activity are revealed by the most popular routes.

- Casual riders’ top start–end pairs often involve **lakefront, downtown, or park-adjacent stations**, which fit leisure and sightseeing usage.
- Members’ top routes more often connect **neighbourhood, campus, or work-adjacent stations**, consistent with commuting or regular routine trips.

This appears on the map as a combination of more organized commute-style routes dominated by members and picturesque waterfront corridors where casual riders are frequently seen.

### 10.6 Overall Picture

In summary:

- **Members**: stronger daily commute patterns, shorter commutes, greater year-round utilization, and more trips overall.
- **Casual riders**: Longer rides, a greater reliance on weekends and warm seasons, fewer trips overall, and a greater presence on routes intended for leisure.

These distinct behavioral differences serve as the basis for the marketing suggestions in the following section.

---

## 11. Act – Recommendations and Next Steps

The data shows a clear split: members behave like year-round, commute-oriented users, while casual riders look more leisure-oriented, with longer trips and heavier weekend and summer use. The recommendations focus on turning those patterns into membership growth.

### 11.1 Focus on Leisure Casual Riders

Casual riders cluster on long rides, weekends, warm months, and scenic routes.

**What to do:**

- At popular casual stations (lakefront, parks, downtown), promote memberships as the better deal for regular weekend or holiday riding.
- Launch seasonal offers before and during peak months (e.g., early summer), using on-station signs or QR codes that lead directly to a simple sign-up flow.
- In the app or by email, show casual riders how a few long rides per month already bring them close to the cost of a membership.

### 11.2 Use Commute Patterns to Sell Stability

Members’ strong weekday morning/evening peaks and their winter riding indicate a commuting use case.

**What to do:**

- Frame membership as the “sensible default” for anyone riding several times a week: predictable monthly cost instead of variable per-ride spending.
- When a casual rider starts to show commute-like behaviour (similar times on weekdays), trigger targeted prompts that compare their recent casual spending with a membership price.

### 11.3 Align Message, Time, and Place – Then Test

The combination of time-of-day, station, and route data points to where campaigns will be most effective.

**What to do:**

- Use weekend and evening slots around leisure routes for “weekend and day-out savings” messaging.
- Use weekday peaks at commute stations for “everyday ride, one simple price” messaging.
- A/B test message variants and track:
  - casual → member conversion rate  
  - short-term retention of new members  
  - changes in ride volume and revenue per rider

In this way, Cyclistic can base its marketing not on guesses, but on concrete differences in how members and casual riders actually use the system.




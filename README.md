# 🐾 Animal Shelter — Austin Animal Center SQL Analysis

**Animal Shelter** is a data engineering and analysis project focused on building a relational database from raw shelter data and uncovering patterns in animal outcomes at the Austin Animal Center.

This project was developed as part of the **IronHack Data Analytics Bootcamp** and covers the full data pipeline: acquisition, transformation, database design, SQL analysis, Python visualisation, and reporting.

---

## Team

- Gabriela Cascione
- Hina Haq
- Hussein Stuck

---

## Data Sources

### Austin Animal Center — Outcomes

| Detail | Info |
|---|---|
| **Source** | [Austin Open Data Portal](https://data.austintexas.gov/Health-Community-Services/Austin-Animal-Center-Outcomes/9t4d-g238) |
| **File** | `austin_shelter.csv` |
| **Records** | 173,775 rows (173,720 after cleaning) |
| **Columns** | 12 (raw) → 8 (cleaned) |
| **Coverage** | October 2013 — May 2025 |

---

## Research Questions & Findings

### Q1 — Are black cats adopted less than cats of other colours?

- **Hypothesis:** Black cats will have a lower adoption rate compared to cats of other coat colours, due to well-documented adoption bias against black animals in shelters.
- **Finding:** Black cats have an adoption rate of **49.70%**, compared to **52.20%** for all other cats combined.

### Q2 — Which animals are being adopted the least?

- **Hypothesis:** Less common animal types (birds, livestock, other) will have significantly lower adoption rates than dogs and cats.
- **Finding:** Overall, **48.7%** of all animals (84,598 out of 173,720) were adopted. By animal type:

| Animal Type | Total Records | Adopted | Adoption Rate |
|---|---|---|---|
| Cat | 69,386 | 35,781 | **51.57%** |
| Dog | 94,474 | 47,475 | **50.25%** |
| Livestock | 34 | 17 | **50.00%** |
| Bird | 876 | 323 | **36.87%** |
| Other | 8,950 | 1,002 | **11.20%** |

### Q3 — What is the average age of adoption per animal type?

- **Hypothesis:** Cats and dogs will be adopted at a younger age on average than other animal types.
- **Finding:** Cats are in fact adopted at the youngest average age. Dogs are adopted later than expected. Full results:

| Animal Type | Avg Age at Adoption (years) |
|---|---|
| Cat | 1.21 |
| Bird | 1.43 |
| Other | 1.37 |
| Livestock | 1.50 |
| Dog | 2.04 |

The hypothesis is **partially confirmed** — cats are adopted at the youngest age, but dogs are actually adopted at an older average age than birds, other animals, and livestock.

---

## Database Design

The raw CSV was normalised into a relational schema with 5 tables:

```
animal_type   breed   color   outcome
      \          |      |       /
       \_______adoption_table__/
```

### Schema

| Table | Primary Key | Description |
|---|---|---|
| `animal_type` | `type_id` | Lookup table for animal types (Dog, Cat, Bird...) |
| `breed` | `breed_id` | Lookup table for breed names |
| `color` | `color_id` | Lookup table for coat colours |
| `outcome` | `outcome_id` | Lookup table for outcome types (Adoption, Transfer...) |
| `adoption_table` | `animal_id` | Main fact table — one row per animal (most recent outcome) |

### Key Design Decisions

- `animal_id` is the primary key in `adoption_table` — only the most recent outcome per animal is kept
- All lookup table IDs use `INTEGER UNSIGNED NOT NULL AUTO_INCREMENT`
- `monthyear`, `name`, `sex_upon_outcome`, and `outcome_subtype` columns were dropped during cleaning
- `age_upon_outcome` is stored as a string (`VARCHAR`) since the raw values are text like `"2 years"` and `"4 months"`
- Dates were parsed using `STR_TO_DATE(LEFT(datetime, 10), '%Y-%m-%d')` to handle inconsistent datetime formats

---

## Data Cleaning

### Steps Applied (Python)

- Dropped unused columns: `name`, `sex_upon_outcome`, `outcome_subtype`, `monthyear`
- Removed rows with any null values: 173,775 → **173,720 rows** (55 rows dropped)
- Reset index after dropping nulls
- Exported clean CSV: `shelter_data_clean.csv`

### Key Challenges

- `datetime` column had inconsistent formats (`2017-07-21T00:00:00-05:00` vs `2015-10-05 9:00:00`) — resolved using `LEFT(datetime, 10)` to extract the date only
- Some animals had multiple outcome records — resolved by keeping only the most recent outcome per `animal_id` using `GROUP BY animal_id` in the population query
- Null values present in `name` and `outcome_subtype` columns (rows removed entirely)

---

## SQL Insights & Advanced Analysis

### Q1 — Black cats vs other cats

- Used `CASE WHEN c.color = 'Black' THEN 'Black' ELSE 'Other' END` to group cats by colour category
- Used conditional `SUM(CASE WHEN outcome_type = 'Adoption' THEN 1 ELSE 0 END)` to calculate per-group adoption counts
- Also computed adoption rate broken down by every individual cat colour
- Note: only cats with the exact label `Black` are counted as black — mixed colours like `Black/White` are counted as "Other"

### Q2 — Adoption rates by animal type

- Grouped by `pet_type` and calculated total records, adopted count, and adoption rate percentage
- Sorted results by adoption rate (descending) and by total records (descending)
- Also computed the overall adoption percentage across all animal types

### Q3 — Average age of adoption

- Used `DATEDIFF(date_outcome, date_birth) / 365` to calculate age at outcome in years
- Filtered by `outcome_type = 'Adoption'` for adoption-specific average age
- Also computed average age for all outcomes and for non-adoption outcomes separately for comparison

---

## Tools Used

- **MySQL** — relational database design and SQL analysis
- **MySQL Workbench** — schema design, ERD generation, and data import
- **Python** (Pandas, Matplotlib, Seaborn) — data analysis and visualisation
- **Jupyter Notebook** — analysis notebooks
- **Git / GitHub** — version control

---

## Repository Structure

```
animal_shelter/
│
├── 01. Data/
│   ├── 01. Raw Data/
│   │   └── austin_shelter.csv
│   ├── 02. Clean Data/
│   │   └── shelter_data_clean.csv
│   └── 03. Tables for visualization/
│       ├── 1_adoption_type.csv
│       ├── 2_adoption_animals_percentage.csv
│       ├── 3_total_adoption_all_animals.csv
│       ├── Adoption_rate_by_color.csv
│       ├── Count_cats_by_color.csv
│       ├── Highest_adoption_rate_by_color.csv
│       ├── adoption_avg_age.csv
│       ├── avg_age_all_animals.csv
│       ├── avg_age_shelter_animals.csv
│       └── black_cats_other_cats.csv
│
├── 02. Python Scripts/
│   ├── shelter_cleaning.ipynb
│   ├── q1_plots.ipynb
│   ├── q2_plots.ipynb
│   └── q3_plots.ipynb
│
├── 03. SQL Scripts/
│   ├── db_creation_SQL.sql
│   ├── db_population.sql
│   ├── q1_queries.sql
│   ├── q2_queries.sql
│   └── q3_queries.sql
│
├── 04. Visualizations/
│   ├── adoption_all_animals.png
│   ├── adoption_percentage.png
│   ├── black_vs_other.png
│   ├── avg_age_adopted.png
│   ├── avg_age_adopted_sorted.png
│   ├── avg_age_all_animals.png
│   ├── avg_age_all_animals_sorted.png
│   ├── avg_age_shelter.png
│   ├── avg_age_shelter_sorted.png
│   └── cats_by_color.png
│
├── ERD_db.png
├── shelter_presentation.pptx
├── .gitignore
└── README.md
```

---

## How to Run

1. Clone the repository:
   ```bash
   git clone https://github.com/craftedbygaby/animal_shelter.git
   cd animal_shelter
   ```

2. Import the raw data into MySQL:
   - Open MySQL Workbench
   - Create schema: `CREATE DATABASE pet_shelter;`
   - Use the Table Data Import Wizard to load `01. Data/01. Raw Data/austin_shelter.csv` as `raw_data` (all columns as `TEXT`)

3. Run the schema and population scripts:
   ```bash
   mysql -u root -p pet_shelter < "03. SQL Scripts/db_creation_SQL.sql"
   mysql -u root -p pet_shelter < "03. SQL Scripts/db_population.sql"
   ```

4. Install Python dependencies:
   ```bash
   pip install pandas matplotlib seaborn jupyter
   ```

---

## Links

- 📊 [Final Presentation](./shelter_presentation.pptx)
- 🗂️ [ERD Diagram](./ERD_db.png)

---

## Limitations

- Only the most recent outcome per animal is stored — historical outcome patterns per individual animal are not captured
- `age_upon_outcome` is stored as raw string — numeric conversion required for age-based analysis
- Dataset is live and updates daily — results may differ depending on when the data was downloaded
- Breed names are not standardised across animal types, which may affect breed-level analysis
- "Black" cats only counts cats with the exact colour label `Black` — cats with mixed colouring such as `Black/White` are counted in the "Other" group

---

*All analysis is for educational and portfolio purposes only.*

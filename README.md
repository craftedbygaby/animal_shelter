# 🐾 Animal Shelter — Austin Animal Center SQL Analysis

**Animal Shelter** is a data engineering and analysis project focused on building a relational database from raw shelter data and uncovering patterns in animal outcomes at the Austin Animal Center.

This project was developed as part of the **IronHack Data Analytics Bootcamp** and covers the full data pipeline: acquisition, transformation, database design, SQL analysis, and reporting.

---

## Team

This project was developed collaboratively as part of the IronHack Data Analytics Bootcamp.

- Gabriela Cascione
- Hina Haq
- Hussein Stuck

---

## Data Sources

### 1. Austin Animal Center — Outcomes

| Detail | Info |
|---|---|
| **Source** | [Austin Open Data Portal](https://data.austintexas.gov/Health-Community-Services/Austin-Animal-Center-Outcomes/9t4d-g238) |
| **File** | `austin_shelter_csv.csv` |
| **Records** | 173,775 rows |
| **Columns** | 12 |
| **Coverage** | October 2013 — present |

---

## Research Questions & Hypotheses

1. **Are black cats adopted less than cats of other colours?**
   - *Hypothesis:* Black cats will have a lower adoption rate compared to cats of other coat colours, due to well-documented adoption bias against black animals in shelters.
   - *Conclusion:* TBD

2. **Which animals are being adopted the least?**
   - *Hypothesis:* Less common animal types (birds, livestock, other) will have significantly lower adoption rates than dogs and cats.
   - Sub-question: What is the total number and percentage of animals adopted across all types?
   - *Conclusion:* TBD

3. **What is the average age of adoption per animal type?**
   - *Hypothesis:* Cats and dogs will be adopted at a younger age on average than other animal types, as younger animals are generally more desirable to adopters.
   - *Conclusion:* TBD

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
- Breed is linked at the **animal level**, not the breed table, since the same breed name can appear across different animal types
- `monthyear` column was dropped as it is redundant with `datetime`
- `age_upon_outcome` is stored as a string (`VARCHAR`) since the raw values are text like `"2 years"` and `"4 months"`

---

## Data Cleaning

### Key Challenges Addressed

- `datetime` column had inconsistent formats (`2017-07-21T00:00:00-05:00`, `2015-10-05 9:00:00`) — resolved using `LEFT(datetime, 10)` to extract the date only
- `sex_upon_outcome` combines spayed/neutered status and sex in one field
- Some animals had multiple outcome records — resolved by keeping only the most recent outcome per `animal_id` using `MAX(date)` and `GROUP BY`
- Null values present in `name` and `outcome_subtype` columns
- Breed names are inconsistent across animal types

---

## SQL Insights & Advanced Analysis

> ⚠️ This section will be updated once SQL analysis is complete.

---

## Main Findings & Insights

> ⚠️ This section will be updated once analysis is complete.

---

## Tools Used

- **MySQL** — relational database design and SQL analysis
- **MySQL Workbench** — schema design, ERD generation, and data import
- **Python** (Pandas, Matplotlib, Seaborn) — data analysis and visualisation
- **Jupyter Notebook** — reporting
- **Git / GitHub** — version control

---

## Repository Structure

```
animal_shelter/
│
├── 01. Data/
│   ├── 01. Raw Data/
│   │   └── austin_shelter.csv
│   └── 02. Clean Data/
│       └── shelter_data_clean.csv
│
├── 02. Python Scripts/
│   └── shelter_cleaning.ipynb
│
├── 03. SQL Scripts/
│   ├── db_creation_SQL.sql
│   └── db_population.sql
│
├── Animal Shelter Heroes.png
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

5. Open the cleaning notebook:
   ```bash
   jupyter notebook "02. Python Scripts/shelter_cleaning.ipynb"
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

---

*All analysis is for educational and portfolio purposes only.*

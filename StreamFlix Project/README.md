# StreamFlix Content Analytics

End-to-end data analytics project analyzing a fictional subscription streaming
platform's subscriber behavior, content performance, and platform engagement — data
cleaning, exploratory data analysis, KPI calculation, SQL analysis, and a Power BI
dashboard with a management report for leadership.

**Analyst:** Eram Aiysha Shaikh
**Level:** Intermediate · **Duration:** 3-4 weeks

---

## Table of contents

- [Business context](#business-context)
- [Project structure](#project-structure)
- [Dataset](#dataset)
- [Tools and setup](#tools-and-setup)
- [Project phases](#project-phases)
- [Progress](#progress)
- [Evaluation rubric](#evaluation-rubric)
- [Submission checklist](#submission-checklist)

---

## Business context

StreamFlix is a subscription video-on-demand (SVOD) platform serving subscribers
across 20 countries, with a catalogue spanning 16 genres across movies and TV series.
Subscribers watch on 6 device types and pay on one of three plans: Basic with Ads
($6.99), Standard ($15.49), or Premium ($22.99).

This project answers the questions StreamFlix leadership needs answered:

- Which genres and titles drive the most watch time, and which underperform?
- Are we losing too many subscribers to churn, and what does an at-risk subscriber
  look like?
- Which subscriber segments (plan, age, region) are most valuable and most engaged?
- Are there seasonal viewing patterns to plan content releases around?
- Which countries/languages are the biggest and fastest-growing markets?
- Is content investment efficient, or are some genres/titles costing more than the
  watch time justifies?

## Project structure

```
streamflix-analytics/
├── data/                                    # raw CSVs + SQL schema (gitignored, not pushed)
│   ├── subscribers.csv
│   ├── titles.csv
│   ├── watch_history.csv
│   ├── ratings.csv
│   ├── reviews.csv
│   ├── watchlist.csv
│   ├── schema_and_sql.sql
│   ├── StreamFlix_Data_Dictionary.docx
│   ├── StreamFlix_ERD.png
│   └── StreamFlix_Project_PRD.docx
├── notebooks/
│   ├── Phase1_DataCleaning_Eram.ipynb
│   ├── Phase2_EDA_Eram.ipynb                 # (upcoming)
│   └── Phase3_KPIs_Eram.ipynb                # (upcoming)
├── dashboard/
│   └── Phase4_Dashboard_Eram.pbix            # (upcoming)
├── reports/
│   └── Phase4_Report_Eram.docx               # (upcoming)
├── requirements.txt
├── .gitignore
└── README.md
```

## Dataset

6 CSV files + 1 SQL schema file, ~979,000 records total. Viewing history spans 2017
to June 2026; subscriber signups go back to 2016.

| File | Records | Description |
|---|---|---|
| `subscribers.csv` | 15,000 | Subscriber profiles, plan, location, churn status |
| `titles.csv` | 9,000 | Content catalogue — genre, cast, licensing, popularity |
| `watch_history.csv` | 650,000 | Every viewing session — the central fact table |
| `ratings.csv` | 130,000 | Star ratings (1-5) given by subscribers to titles |
| `reviews.csv` | 110,000 | Written reviews with sentiment and helpful votes |
| `watchlist.csv` | 65,000 | Titles subscribers saved, and whether they later watched |
| `schema_and_sql.sql` | — | SQL `CREATE TABLE` statements + 12 analytical queries |

Full column-level definitions are in `data/StreamFlix_Data_Dictionary.docx`. The raw
data files themselves are **not pushed to GitHub** (see `.gitignore`) — only
analysis code and outputs are version-controlled.

## Tools and setup

- Python (pandas, numpy, matplotlib, seaborn) — cleaning, EDA, KPIs
- SQL — 12 reference queries in `schema_and_sql.sql`
- Power BI Desktop (or Excel as an alternative) — final dashboard
- Jupyter / VS Code — notebook development

```bash
conda create -n streamflix python=3.11 -y
conda activate streamflix
conda install pandas matplotlib seaborn openpyxl numpy jupyter -y
```

Place the 6 dataset CSVs and `schema_and_sql.sql` in `data/`, then open notebooks in
`notebooks/` and run top to bottom.

## Project phases

| Phase | Deliverable | Skills | Est. time |
|---|---|---|---|
| 1 | Data Loading, Cleaning & Quality Report | Python/Excel, pandas | 5-6 hrs |
| 2 | Exploratory Data Analysis (10 charts) | pandas, matplotlib/seaborn | 6-8 hrs |
| 3 | Business KPI Calculations & Insights | Python/SQL/Excel | 6-8 hrs |
| 4 | Power BI Dashboard + Management Report | Power BI/Excel/Python | 8-10 hrs |

### Phase 1 — Data cleaning and quality check

Load all 6 tables, profile each (row/column count, dtypes), check missing values and
duplicates, validate data types, flag outliers in `watch_duration_min`, verify
referential integrity, and write a data quality report. Specific checks required:
`churn_date` occurs after `signup_date`; active subscribers have no `churn_date`;
`completion_pct` matches `watch_duration_min ÷ content_duration_min × 100`;
`sentiment` only contains Positive/Neutral/Negative; every `watchlist` entry links to
a real subscriber and title.

**Deliverable:** `Phase1_DataCleaning_Eram.ipynb`

### Phase 2 — Exploratory data analysis

10 required charts, each with 2-3 sentences of written observation: monthly viewing
volume, monthly watch-hours trend (YoY), genre-wise watch-hours share, movies vs. TV
shows split, top 10 countries by watch hours, subscriber plan distribution, device
usage, age distribution, completion rate by genre, review sentiment breakdown.

**Deliverable:** `Phase2_EDA_Eram.ipynb` (charts also saved as PNG)

### Phase 3 — KPI calculations

| KPI | Formula | Target |
|---|---|---|
| Total Watch Hours | `SUM(watch_duration_min) / 60` | — |
| Active Rate | Active ÷ Total × 100 | > 70% |
| Churn Rate | Inactive ÷ Total × 100 | < 30% |
| Avg Completion Rate | `AVG(completion_pct)` | > 60% |
| MRR | `SUM(monthly_price)` for active subs | — |
| ARPU | MRR ÷ Active Subscribers | — |
| Avg Watch Time / Subscriber | Total Watch Hours ÷ Active Subs | — |
| Watchlist Conversion | Watched ÷ Watchlist Entries × 100 | > 40% |
| Hit Concentration | Plays from top 10% titles ÷ Total × 100 | — |
| Originals Share of Hours | Hours on Originals ÷ Total Hours × 100 | — |

**Bonus:** Cohort retention — group subscribers by signup month, track what % are
still active at 3/6/12 months (+5 marks).

**Deliverable:** `Phase3_KPIs_Eram.ipynb`

### Phase 4 — Dashboard and management report

**Dashboard** (Power BI or Excel), 5 pages, each with a title, ≥2 charts, ≥1
filter/slicer, and a key-insights text box:

1. Engagement Overview — watch-hours trend, subscriber count, completion/churn cards
2. Content Performance — watch hours by genre, top 10 titles, completion by genre
3. Subscriber Insights — plan breakdown, top 10 countries, new subs per month
4. Experience — device breakdown, rating distribution, sentiment analysis
5. Catalogue & Investment — Originals vs. Licensed, watch hours per $1K spend,
   upcoming license expiries

**Management report** (2-3 pages, Word/PDF, addressed to the CEO, plain language, no
jargon): Executive Summary, Top 3 Findings, Risks Identified, Opportunities, and at
least 3 specific recommendations.

**Deliverables:** `Phase4_Dashboard_Eram.pbix`/`.xlsx` + `Phase4_Report_Eram.docx`/`.pdf`

## Progress

| Phase | Status |
|---|---|
| 1 — Data Cleaning & Quality Report | ✅ Complete |
| 2 — Exploratory Data Analysis | ✅ Complete |
| 3 — KPI Calculations | ⏳ Not started |
| 4 — Dashboard & Management Report | ⏳ Not started |

**Phase 1 summary:** All 6 tables loaded and profiled against expected row counts.
The only two null columns found — `churn_date` and `license_expiry` — are missing by
design, not error. Zero duplicate primary keys across any table. All required
business-logic and referential-integrity checks (churn date ordering, active/churn
consistency, watch duration validity, completion % accuracy, foreign key integrity
across all child tables, category value consistency) passed with zero violations.
Full detail in `notebooks/Phase1_DataCleaning_Eram.ipynb`.

**Phase 2 summary:** All 10 required charts built with written observations. Viewing
volume and watch hours show sustained, accelerating growth across the platform's
history. Drama, Comedy, and Action are the top genres by watch hours; Movies edge out
TV Shows (59% vs. 41%) in session share. The US is the largest market by a wide
margin, though India, South Korea, and Brazil show meaningful engagement. Plan
distribution is close to an even 3-way split. Smart TV and Mobile dominate device
usage. Completion rate is consistent across genres (~65% band). Review sentiment
skews strongly positive (68%). Full detail in `notebooks/Phase2_EDA_Eram.ipynb`.

## Evaluation rubric

Total: 100 marks (+5 bonus)

| Criteria | Marks |
|---|---|
| Phase 1: Data Cleaning & QC Report | 15 |
| Phase 2: EDA Charts (10 charts) | 20 |
| Phase 3: KPI Calculations | 25 |
| Phase 4: Dashboard Quality | 20 |
| Phase 4: Management Report | 15 |
| Bonus: Cohort Retention | +5 |

## Submission checklist

- [x] `Phase1_DataCleaning_Eram.ipynb`
- [x] `Phase2_EDA_Eram.ipynb` (all 10 charts, also saved as PNG)
- [ ] `Phase3_KPIs_Eram.ipynb` (all 10 KPIs)
- [ ] `Phase4_Dashboard_Eram.pbix`/`.xlsx` (5 pages, slicers)
- [ ] `Phase4_Report_Eram.docx`/`.pdf` (2-3 pages)
- [ ] All files named correctly
- [ ] No hardcoded numbers — every figure traces back to the analysis
- [ ] No raw data files shared, only analysis outputs

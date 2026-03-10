# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a dbt learning project called **Jaffle Shop** — a sample ecommerce analytics data warehouse targeting **Snowflake**. It models customer and order data (Jaffle Shop source) and payment data (Stripe source) into a dimensional model.

- dbt project name: `jaffle_shop`
- Profile name: `jaffle_shop` (profiles.yml lives outside the repo, configured locally)
- Target warehouse: Snowflake

## Common Commands

```bash
# Install packages
dbt deps

# Run all models
dbt run

# Run a specific model and its downstream dependencies
dbt run --select +<model_name>+

# Run only staging models
dbt run --select staging

# Run tests
dbt test

# Run tests for a specific model
dbt test --select <model_name>

# Load seed files
dbt seed

# Check source freshness
dbt source freshness

# Compile without running (useful for inspecting generated SQL)
dbt compile

# Generate and serve docs
dbt docs generate
dbt docs serve
```

## Architecture

The project follows a three-layer architecture:

```
sources (raw.jaffle_shop, raw.stripe)
  └── staging/          → views, one-to-one with source tables, light cleaning only
        ├── jaffle_shop/  (customers, orders)
        └── stripe/       (payments)
            └── marts/
                  ├── core/      → intermediate models (int_*)
                  ├── finance/   → fact tables (fct_orders)
                  └── marketing/ → dimension tables (dim_customers)
```

**Materialization defaults** (set in `dbt_project.yml`):
- `staging/` → `view`
- `marts/` → `table`

## Key Models

| Model | Layer | Purpose |
|---|---|---|
| `stg_jaffle_shop__customers` | staging | Cleaned customer records |
| `stg_jaffle_shop__orders` | staging | Cleaned order records with status |
| `stg_stripe__payments` | staging | Payments with cents→dollars conversion |
| `int_orders__pivoted` | core | Payments pivoted by payment method |
| `fct_orders` | finance | Central fact table joining orders + payments |
| `dim_customers` | marketing | Customer dimension with lifetime value metrics |
| `all_dates` | utility | Date spine from 2020-01-01 to 2021-01-01 |

## Custom Macros

- **`cent_to_dollar(amount_column, decimals=2)`** — divides by 100 and rounds; used in `stg_stripe__payments`
- **`limit_dev()`** — returns `LIMIT 20` when `target.name == 'dev'`, otherwise nothing; wrap around staging queries for faster dev runs

## Packages

- `dbt-labs/codegen` — generates model YAML boilerplate
- `dbt-labs/dbt_utils` — provides `date_spine` and other utilities
- `brooklyn-data/dbt_artifacts` — captures run metadata for monitoring

## Naming Conventions

- Staging models: `stg_<source>__<entity>.sql` (double underscore separates source from entity)
- Intermediate models: `int_<entity>__<verb>.sql`
- Fact tables: `fct_<entity>.sql`
- Dimension tables: `dim_<entity>.sql`
- Source YAML files: `_src_<source>.yml`
- Staging schema YAML files: `_stg_<source>.yml`

## Tests

Generic tests are defined in YAML schema files. One singular test exists:

- `tests/assert_stg_stripe__payment_totoal_positive.sql` — ensures total payment amounts per order are non-negative

Source freshness thresholds:
- `jaffle_shop.orders`: warn after 10 days, error after 30 days
- `stripe.payment`: warn after 12 hours, error after 24 hours

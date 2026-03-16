-- models/marts/dim_date.sql
{{ config(materialized='table') }}

with date_spine as (
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('2025-01-01' as date)",
        end_date="cast('2026-12-31' as date)"
    ) }}
)
select
    date_day,
    date_trunc('week', date_day)   as week_start,
    date_trunc('month', date_day)  as month_start,
    dayofweek(date_day)            as day_of_week,
    weekofyear(date_day)           as week_of_year,
    year(date_day)                 as year
from date_spine
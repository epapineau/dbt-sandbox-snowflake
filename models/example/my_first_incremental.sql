{{
    config(
        materialized='incremental',
        on_schema_change='sync_all_columns'
    )
}}

select 1 as column_a, 2 as column_b
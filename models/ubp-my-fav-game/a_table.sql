{{
    config(
        materialized='table'
    )
}}

select * from {{ ref('an_ephemeral') }}
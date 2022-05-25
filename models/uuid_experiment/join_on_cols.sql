{{ config(materialized='table') }}

with

uuid_data as (

    select * from {{ ref('stg_uuid_data') }}

),

self_join as (

    select 
        uuid_data.surrogate_key,
        uuid_data2.surrogate_key as surrogate_key2,

        uuid_data.source_name,
        uuid_data2.source_name as source_name2,

        uuid_data.source_id,
        uuid_data2.source_id as source_id2
        
    from uuid_data
    left join uuid_data as uuid_data2
    on uuid_data.source_name = uuid_data2.source_name
    and uuid_data.source_id = uuid_data2.source_id

)

select * from self_join
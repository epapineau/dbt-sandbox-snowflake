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
    on uuid_data.surrogate_key = uuid_data2.surrogate_key

)

select * from self_join

-- which joining method is more performant
-- perfomant == seconds of query time
-- spin up and down warehouse 
-- use a left join because it's slightly more perfomant than an inner join
-- materialize join models as tables to ensure data is executed

-- as we scale up test points
-- seeds may not support large enough number of rows for this experiment
-- Potentially use a stored procedure to generate enough rows
-- or use Snowflake sample data
-- select count(*) from "RAW_TPCH"."TPCH_SF100"."CUSTOMER";



-- clustering considerations: snowflake self clustering cutoff is ~1 billion

-- follow ups:
-- make dedicated warehouse
-- test across scales

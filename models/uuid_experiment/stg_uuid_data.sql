with

seed as (

    select * from {{ ref('concatonated_pks') }}

),

final as(

    select
        {{ dbt_utils.surrogate_key(['SOURCE_NAME', 'SOURCE_ID']) }} as surrogate_key,
        source_name,
        source_id

    from seed

)

select * from final
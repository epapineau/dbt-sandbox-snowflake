with orders as (

    select * from {{ ref('stg_orders') }}

),

final as (

    select
        orders.*
        max(orders.created_at) as most_recent_order


)

select * final
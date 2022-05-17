{% snapshot example_snapshot %}
{{
    config(
        target_database='development',
        target_schema='dbt_epapineau_dev',
        unique_key='user_id',
        strategy='timestamp',
        updated_at='current_time'
    )
}}


select 1 as user_id, to_timestamp_ltz(current_timestamp(2)) as current_time

{% endsnapshot %}
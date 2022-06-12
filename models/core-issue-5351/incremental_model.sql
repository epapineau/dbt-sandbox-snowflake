{{ config (
    materialized="incremental",
    unique_key="user_id_date",
    incremental_strategy="merge",
    on_schema_change="sync_all_columns"
) }}

select
    1 || '-' || current_timestamp as user_id_date,

    {% if is_incremental() %}
        'thisis18characters' as platform
    {% else %}
        'okthisis20characters' as platform
    {% endif %}
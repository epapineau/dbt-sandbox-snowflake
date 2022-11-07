{{ config(
    materialized = 'table'
)}}

with

run_results as (

    select * from {{ source('snowflake_sandbox', 'run_results_json') }}

),

unpack_json as (

    {# Unnesting to second-level keys to keep parity with how BQ handles json #}
    {# TODO: Above ^ #}
    {# TODO: Finalize desired schema of this model #}
    select
        src:args:event_buffer_size as args__event_buffer_size,
        src:args:indirect_selection::string as args__indirect_selection,
        src:args:partial_parse as args__partial_parse,
        src:args:printer_width as args__printer_width,
        src:args:profiles_dir::string as args__profiles_dir,
        src:args:rpc_method::string as args__rpc_method,
        src:args:send_anonymous_usage_stats as args__send_anonymous_usage_stats,
        src:args:static_parser as args__static_parser,
        src:args:use_colors as args__use_colors,
        src:args:version_check as args__version_check,
        src:args:which as args__which,
        src:args:write_json as args__write_json,

        src:metadata:env as metadata__env,
        src:metadata:invocation_id::string as metadata__invocation_id,
        src:metadata:dbt_version::string as metadata__dbt_version,
        src:metadata:generated_at::timestamp as metadata__generated_at,
        src:metadata:dbt_schema_version::string as metadata__dbt_schema_version,

        results.value:failures as results__failures,
        results.value:message::string as results__message,

        timing.value:completed_at::timestamp as timing__completed_at,
        timing.value:name::string as timing__name,
        timing.value:started_at::timestamp as timing__started_at,

        results.value:thread_id::string as results__thread_id,
        results.value:adapter_response as results__adapter_response,
        results.value:unique_id::string as results__unique_id,
        results.value:execution_time as results__execution_time,
        results.value:status::string as results__status

    from run_results,
    lateral flatten(input => src:results) results,
    lateral flatten(input => results.value:timing) timing

)

select * from unpack_json
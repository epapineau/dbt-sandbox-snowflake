{%- macro sf_upload_json() -%}

{%- set stage_name -%}
    {{ target.database }}.{{ target.schema }}.test_dbt_information_schema_stage
{%- endset -%}
{% set table_name %}
    {{ target.database }}.{{ target.schema }}.run_results_json
{% endset %}

{{ log(stage_name, info=True) }}

{% set create_stage %}
    create stage if not exists {{ stage_name }}
    file_format = (type = json)
{% endset %}

{{ log(create_stage, info=True) }}
{% do run_query (create_stage) %}

{% set put_statement %}
    put 'file://target/run_results.json' @{{ stage_name }} overwrite = true
{% endset %}

{{ log(put_statement, info=True) }}
{% do run_query (put_statement) %}

{% set create_table %}
    create table if not exists {{ table_name }} (src variant)
{% endset %}

{{ log(create_table, info=True) }}
{% do run_query (create_table) %}

{% set copy_statement %}
    copy into {{ table_name }}
    from @{{ stage_name }}/run_results.json.gz
{% endset %}

{{ log(copy_statement, info=True) }}
{% do run_query (copy_statement) %}

{% endmacro %}
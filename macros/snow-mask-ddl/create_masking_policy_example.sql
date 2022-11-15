{%- macro create_masking_policy_example(node_database, node_schema) -%}

    create masking policy if not exists {{ node_database }}.{{ node_schema }}.example as (val string)
        returns string ->
         case
            when current_role() in ('TRANSFORMER')
                then val
            else '*******'
        end

{%- endmacro -%}
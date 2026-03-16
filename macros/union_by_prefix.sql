{% macro union_by_prefix(database, schema, prefix) %}

    {# execute guard — always first #}
    {% if not execute %}
        {{ return('') }}
    {% endif %}

    {% set relations = dbt_utils.get_relations_by_prefix(
        database=database,
        schema=schema,
        prefix=prefix
    ) %}

    {{ log(
        "Found " ~ relations | length ~ " tables with prefix '"
        ~ prefix ~ "' in schema '" ~ schema ~ "'",
        info=true
    ) }}

    {% set union_sql %}
        {% for relation in relations %}
            {{ log("  Adding: " ~ relation.identifier, info=true) }}
            {%- if not loop.first %} union all {% endif %}
            select * from {{ relation }}
        {% endfor %}
    {% endset %}

    {{ return(union_sql) }}

{% endmacro %}
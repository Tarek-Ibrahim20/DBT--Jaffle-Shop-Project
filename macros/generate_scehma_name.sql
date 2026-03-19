-- macros/generate_schema_name.sql

{% macro generate_schema_name(custom_schema_name, node) %}

    {% if target.name == 'prod' %}

        {# prod → use the clean name exactly as written #}
        {{ custom_schema_name | trim }}

    {% elif custom_schema_name %}

        {# dev → prefix with your personal schema name #}
        {{ target.schema }}_{{ custom_schema_name | trim }}

    {% else %}

        {# fallback → just use whatever is in profiles.yml #}
        {{ target.schema }}

    {% endif %}

{% endmacro %}
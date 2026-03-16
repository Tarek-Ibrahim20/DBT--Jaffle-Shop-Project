{% macro get_current_day()%}

{% set results = run_query("SELECT CURRENT_DATE()") %}
{% set today = results.columns[0].values()[0] %}
{{ log("Today is: " ~ today, info=true) }}

{% endmacro %}
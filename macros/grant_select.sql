{% macro granting_access (database = target.database ,schema = target.schema , role= target.role) %}

{% set sql_grant %}
    grant usage on database {{database}} to {{role}};
    grant usage on schema {{database}}.{{schema}} to {{role}};
    grant select on all tables in schema  {{database}}.{{schema}} to {{role}};
{%endset%}

{% do run_query(sql_grant)%}

{{ log ( 'granting usage on database ' ~ database ~ ' & schema ' ~ schema ~ 'to role ' ~ role , info  )}}

{%endmacro%}
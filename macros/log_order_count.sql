{% macro log_order_count() %}

    {% set sql %}
        select distinct status, count(*) as cnt
        from raw.jaffle_shop.orders
        group by 1
        order by 2 desc
    {% endset %}

    {% set results = run_query(sql) %}

    {{ log("[orders] Status breakdown:", info=true) }}

    {# Loop over every row in the result set #}
    {% for row in results.rows %}

        -- {# row[0] = status, row[1] = count #}
        {{ log(
             loop.index ~ ". " ~ row[0]
            ~ " → " ~ row[1] ~ " orders",
            info=true
        ) }}

    {% endfor %}

{% endmacro %}
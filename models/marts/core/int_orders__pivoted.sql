{% set payment_methods = ["bank_transfer", "credit_card", "coupon", "gift_card"] %}

-- pivoting using jinja 


-- with payments as (
--     select
--         * 
--     from {{ ref('stg_stripe__payments')}}
-- ),
-- pivotd as(
-- select   order_id ,
--     {% for method in payment_methods %}
--         sum(case when payment_method = '{{ method }}' then amount else 0 end) as {{ method }}_amount
--     {% if not loop.last %} , {% endif %}
--     {% endfor %}
-- from payments    
-- group by 1    
-- )

-- select * from pivotd

-- models/marts/fct_orders.sql


-- pivoting using util macros 

with payments as (
    select * from {{ ref('stg_stripe__payments') }}
),
pivoted as (
    select
        order_id,
        {{ dbt_utils.pivot(
            column='payment_method',
            values=payment_methods,
            agg='sum',
            then_value='amount'
        ) }}
    from payments
    group by order_id
)
select * from pivoted

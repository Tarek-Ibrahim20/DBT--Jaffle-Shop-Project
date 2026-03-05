{%- macro cent_to_dollar(amount_column , decimals = 2) -%}
    round({{ amount_column }} * 1.0 / 100, {{ decimals }})
{%- endmacro -%}
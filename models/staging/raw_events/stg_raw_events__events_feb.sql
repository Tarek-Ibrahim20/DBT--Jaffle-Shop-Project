with source as (

    select * from {{ source('raw_events', 'events_feb') }}

),

renamed as (

    select
        event_id,
        user_id,
        event_type,
        event_date,
        page_url,
        amount

    from source

)

select * from renamed

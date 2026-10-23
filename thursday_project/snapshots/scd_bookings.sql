{% snapshot scd_bookings %}

{{
    config(
        target_schema='snapshots',
        unique_key='BOOKING_ID',
        strategy='check',
        check_cols=[
            'BOOKING_STATUS',
            'BOOKING_AMOUNT',
            'CLEANING_FEE',
            'SERVICE_FEE',
            'NIGHTS_BOOKED'
        ]
    )
}}

SELECT *
FROM {{ source('source', 'BOOKINGS') }}

{% endsnapshot %}


{% snapshot scd_listings %}

{{
    config(
        target_schema='snapshots',
        unique_key='LISTING_ID',
        strategy='check',
        check_cols=[
            'HOST_ID',
            'PROPERTY_TYPE',
            'ROOM_TYPE',
            'CITY',
            'COUNTRY',
            'ACCOMMODATES',
            'BEDROOMS',
            'BATHROOMS',
            'PRICE_PER_NIGHT'
        ]
    )
}}

SELECT *
FROM {{ source('source', 'LISTINGS') }}

{% endsnapshot %}

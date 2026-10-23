
{{
    config(
        materialized='table',
        schema='gold_dim'
    )
}}

WITH listings AS (

    SELECT
        LISTING_ID,
        HOST_ID,
        PROPERTY_TYPE,
        ROOM_TYPE,
        CITY,
        COUNTRY,
        ACCOMMODATES,
        BEDROOMS,
        BATHROOMS
    FROM {{ ref('s_listings') }}

),

hosts AS (

    SELECT
        HOST_ID,
        HOST_NAME,
        HOST_SINCE,
        IS_SUPERHOST,
        RESPONSE_RATE
    FROM {{ ref('s_hosts') }}

),

dim_location AS (

    SELECT
        l.LISTING_ID,
        l.HOST_ID,
        h.HOST_NAME,
        h.HOST_SINCE,
        h.IS_SUPERHOST,
        h.RESPONSE_RATE,
        l.PROPERTY_TYPE,
        l.ROOM_TYPE,
        l.CITY,
        l.COUNTRY,
        l.ACCOMMODATES,
        l.BEDROOMS,
        l.BATHROOMS

    FROM listings l

    LEFT JOIN hosts h
        ON l.HOST_ID = h.HOST_ID

)

SELECT *
FROM dim_location

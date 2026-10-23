{{
    config
        (materialized='table',
        schema='gold')
    
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
        BATHROOMS,
        PRICE_PER_NIGHT,
        LISTING_CAPACITY_CATEGORY,
        PRICE_TIER,
        CREATED_AT
    FROM {{ ref('s_listings') }}),

hosts AS (

    SELECT
        HOST_ID,
        HOST_SINCE,
        HOST_SINCE_YEAR,
        IS_SUPERHOST,
        RESPONSE_RATE,
        RESPONSE_RATE_CATEGORY
    FROM {{ ref('s_hosts') }})

SELECT
    l.LISTING_ID,
    l.HOST_ID,
    l.PROPERTY_TYPE,
    l.ROOM_TYPE,
    l.CITY,
    l.COUNTRY,
    l.ACCOMMODATES,
    l.BEDROOMS,
    l.BATHROOMS,
    l.LISTING_CAPACITY_CATEGORY,
    l.PRICE_PER_NIGHT,
    l.PRICE_TIER,
    h.HOST_SINCE,
    h.HOST_SINCE_YEAR,
    h.IS_SUPERHOST,
    h.RESPONSE_RATE,
    h.RESPONSE_RATE_CATEGORY,
    DATEDIFF('day',h.HOST_SINCE,CURRENT_DATE()) AS HOST_TENURE_DAYS,
   
    CASE
        WHEN l.ACCOMMODATES > 0
            AND l.BEDROOMS >= 0
            AND l.BATHROOMS >= 0
            AND l.PRICE_PER_NIGHT > 0
        THEN TRUE
        ELSE FALSE
    END AS IS_LISTING_DATA_COMPLETE,

    l.CREATED_AT

FROM listings l
LEFT JOIN hosts h
    ON l.HOST_ID = h.HOST_ID

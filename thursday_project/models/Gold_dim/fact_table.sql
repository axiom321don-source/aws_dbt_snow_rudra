
{{
    config(
        materialized='table',
        schema='gold_dim'
    )
}}

WITH bookings AS (

    SELECT
        LISTING_ID,
        HOST_ID,
        BOOKING_ID,
        BOOKING_DATE,
        CREATED_AT,
        TOTAL_PAID
    FROM {{ ref('gold_bookings') }}

),

hosts AS (

    SELECT
        HOST_ID,
        HOST_NAME,
        HOST_SINCE
    FROM {{ ref('gold_hosts') }}

),

listings AS (

    SELECT
        LISTING_ID,
        IS_LISTING_DATA_COMPLETE,
        PROPERTY_TYPE,
        ACCOMMODATES
    FROM {{ ref('gold_listings') }}

),

listing_dim AS (

    SELECT
        LISTING_ID,
        LISTING_KEY
    FROM {{ ref('dim_listings') }}

),

hosts_dim AS (

    SELECT
        HOST_ID,
        HOST_KEY
    FROM {{ ref('dim_hosts') }}

)

SELECT
    {{ dbt_utils.generate_surrogate_key(['B.BOOKING_ID']) }} AS BOOKING_KEY,

    LD.LISTING_KEY,
    HD.HOST_KEY,

    B.BOOKING_ID,
    B.BOOKING_DATE,
    B.CREATED_AT,
    B.TOTAL_PAID,

    H.HOST_NAME,
    H.HOST_SINCE,

    L.IS_LISTING_DATA_COMPLETE,
    L.PROPERTY_TYPE,
    L.ACCOMMODATES

FROM bookings B

LEFT JOIN listings L
    ON B.LISTING_ID = L.LISTING_ID

LEFT JOIN hosts H
    ON B.HOST_ID = H.HOST_ID

LEFT JOIN listing_dim LD
    ON B.LISTING_ID = LD.LISTING_ID

LEFT JOIN hosts_dim HD
    ON B.HOST_ID = HD.HOST_ID

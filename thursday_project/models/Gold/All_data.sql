
{{
    config(
        materialized='table',
        schema='gold'
    )
}}

WITH bookings AS (
    SELECT *
    FROM {{ ref('s_bookings') }}
),

listings AS (
    SELECT *
    FROM {{ ref('s_listings') }}
),

hosts AS (
    SELECT *
    FROM {{ ref('s_hosts') }}
)

SELECT
    -- Booking columns
    b.BOOKING_ID,
    b.LISTING_ID,
    b.BOOKING_DATE,
    b.NIGHTS_BOOKED,
    b.BOOKING_AMOUNT,
    b.CLEANING_FEE,
    b.SERVICE_FEE,
    b.BOOKING_STATUS,
    b.CREATED_AT AS BOOKING_CREATED_AT,
    b.DBT_LOADED_AT,
    b.DBT_LOADED_BY,
    b.DBT_LOADED_BY_ROLE,
    b.ROOM_TOTAL,
    b.TOTAL_FEES,
    b.TOTAL_PAID,
    b.BOOKING_DAY,
    b.BOOKING_MONTH,
    b.BOOKING_YEAR,
    b.CHECKOUT_DATE,
    b.QUARTER_NUMBER,
    b.QUARTER_NAME,
    b.SEASON,
    l.PROPERTY_TYPE,
    l.ROOM_TYPE,
    l.CITY,
    l.COUNTRY,
    l.ACCOMMODATES,
    l.BEDROOMS,
    l.BATHROOMS,
    l.PRICE_PER_NIGHT,
    l.CREATED_AT AS LISTING_CREATED_AT,
    h.HOST_NAME,
    h.HOST_SINCE,
    h.IS_SUPERHOST,
    h.RESPONSE_RATE,
    h.CREATED_AT AS HOST_CREATED_AT

FROM bookings AS b

FULL OUTER JOIN listings AS l
    ON b.LISTING_ID = l.LISTING_ID

FULL OUTER JOIN hosts AS h
    ON l.HOST_ID = h.HOST_ID

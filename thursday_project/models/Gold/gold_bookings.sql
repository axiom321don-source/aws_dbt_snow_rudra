
{{
    config(
        materialized='table',
        schema='gold'
    )
}}

WITH bookings AS (

    SELECT
        BOOKING_ID,
        LISTING_ID,
        BOOKING_DATE,
        NIGHTS_BOOKED,
        BOOKING_AMOUNT,
        CLEANING_FEE,
        SERVICE_FEE,
        BOOKING_STATUS,
        CREATED_AT,
        TOTAL_PAID,
        TOTAL_FEES,
        BOOKING_DAY,
        BOOKING_MONTH,
        BOOKING_YEAR
    FROM {{ ref('s_bookings') }}

),

listings AS (

    SELECT
        LISTING_ID,
        HOST_ID
    FROM {{ ref('s_listings') }}

),

fact_bookings AS (

    SELECT
        b.BOOKING_ID,
        b.LISTING_ID,
        l.HOST_ID,
        b.BOOKING_DATE,
        b.BOOKING_STATUS,
        b.NIGHTS_BOOKED,
        b.BOOKING_AMOUNT,
        b.CLEANING_FEE,
        b.SERVICE_FEE,
        b.CREATED_AT,
        b.TOTAL_PAID,
        b.TOTAL_FEES,
        b.BOOKING_DAY,
        b.BOOKING_MONTH,
        b.BOOKING_YEAR

    FROM bookings b

    LEFT JOIN listings l
        ON b.LISTING_ID = l.LISTING_ID

)

SELECT *
FROM fact_bookings


{{
    config(
        materialized='incremental',
        unique_key='BOOKING_ID',
        schema='silver',
        on_schema_change='append_new_columns'
    )
}}

WITH source_data AS (

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
        DBT_LOADED_AT,
        DBT_LOADED_BY,
        DBT_LOADED_BY_ROLE
    FROM {{ ref('bookings') }}


    {% if is_incremental() %}
    WHERE DBT_LOADED_AT >= (
        SELECT COALESCE(     
            MAX(DBT_LOADED_AT),
            '1900-01-01'::TIMESTAMP_NTZ
        )
        FROM {{ this }}
    )
{% endif %}
 
),
-- dbt_loaded_at >= can also process same tiemstamp if we want to avoid that we can

 -- Incremental load using CREATED_AT with a 5-day lookback window
--{% if is_incremental() %}
 --   WHERE CREATED_AT >= (
   --     SELECT COALESCE(
    --        DATEADD(day, -5, MAX(CREATED_AT)),
      --      '1900-01-01'::TIMESTAMP_NTZ)
        --FROM {{ this }})
--{% endif %}
cost_data AS (

    SELECT
        *,
        {{ multiply('NIGHTS_BOOKED', 'BOOKING_AMOUNT', 2) }} AS ROOM_TOTAL,

        ROUND(
            COALESCE(CLEANING_FEE, 0)
            + COALESCE(SERVICE_FEE, 0),
            2
        ) AS TOTAL_FEES,

        ROUND(
            {{ multiply('NIGHTS_BOOKED', 'BOOKING_AMOUNT', 2) }}
            + COALESCE(CLEANING_FEE, 0)
            + COALESCE(SERVICE_FEE, 0),
            2
        ) AS TOTAL_PAID

    FROM source_data

),

dates AS (

    SELECT
        *,
        DAY(BOOKING_DATE) AS BOOKING_DAY,
        MONTHNAME(BOOKING_DATE) AS BOOKING_MONTH,
        YEAR(BOOKING_DATE) AS BOOKING_YEAR,

        TO_DATE(
            DATEADD('day', NIGHTS_BOOKED, BOOKING_DATE)
        ) AS CHECKOUT_DATE

    FROM cost_data

),

quarters AS (

    SELECT
        *,
        QUARTER(BOOKING_DATE) AS QUARTER_NUMBER,
        CONCAT('Q', QUARTER(BOOKING_DATE)) AS QUARTER_NAME,

        CASE
            WHEN MONTH(BOOKING_DATE) IN (12, 1, 2)
                THEN 'Winter'
            WHEN MONTH(BOOKING_DATE) IN (3, 4, 5)
                THEN 'Spring'
            WHEN MONTH(BOOKING_DATE) IN (6, 7, 8)
                THEN 'Summer'
            ELSE 'Fall'
        END AS SEASON

    FROM dates

)

SELECT *
FROM quarters



{{
    config(
        materialized='incremental',
        unique_key='LISTING_ID',
        schema='silver',
        on_schema_change='append_new_columns'
    )
}}

WITH source_listings AS (

    SELECT *
    FROM {{ ref('listings') }}

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

classified_listings AS (

    SELECT
        *,
        CASE
            WHEN ACCOMMODATES IS NULL OR ACCOMMODATES <= 0
                THEN 'Unknown'
            WHEN ACCOMMODATES <= 2
                THEN 'Small (1-2)'
            WHEN ACCOMMODATES BETWEEN 3 AND 5
                THEN 'Medium (3-5)'
            WHEN ACCOMMODATES >= 6
                THEN 'Large (6+)'
        END AS LISTING_CAPACITY_CATEGORY,

        CASE
            WHEN PRICE_PER_NIGHT IS NULL OR PRICE_PER_NIGHT <= 0
                THEN 'Unpriced'
            WHEN PRICE_PER_NIGHT < 50
                THEN 'Budget'
            WHEN PRICE_PER_NIGHT <= 150
                THEN 'Standard'
            WHEN PRICE_PER_NIGHT <= 300
                THEN 'Premium'
            ELSE 'Luxury'
        END AS PRICE_TIER,

        CASE
            WHEN BEDROOMS IS NULL OR BEDROOMS < 0
                THEN 'Unknown'
            WHEN BEDROOMS = 0
                THEN 'Studio / No bedroom'
            WHEN BEDROOMS = 1
                THEN '1 Bedroom'
            WHEN BEDROOMS BETWEEN 2 AND 3
                THEN '2-3 Bedrooms'
            WHEN BEDROOMS >= 4
                THEN '4+ Bedrooms'
        END AS BEDROOM_CATEGORY,

        CASE
            WHEN BATHROOMS IS NULL OR BATHROOMS < 0
                THEN 'Unknown'
            WHEN BATHROOMS = 0
                THEN 'No bathroom recorded'
            WHEN BATHROOMS = 1
                THEN '1 Bathroom'
            WHEN BATHROOMS BETWEEN 2 AND 3
                THEN '2-3 Bathrooms'
            WHEN BATHROOMS >= 4
                THEN '4+ Bathrooms'
        END AS BATHROOM_CATEGORY,

        CASE
            WHEN PRICE_PER_NIGHT > 0
                 AND ACCOMMODATES > 0
            THEN ROUND(
                PRICE_PER_NIGHT / ACCOMMODATES,
                2
            )
            ELSE NULL
        END AS PRICE_PER_PERSON

    FROM source_listings

)

SELECT *
FROM classified_listings

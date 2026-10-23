
{{
    config(
        materialized='table',
        schema='gold_dim'
    )
}}

SELECT
    SHA2(
        CONCAT(
            TO_VARCHAR(LISTING_ID),
            '|',
            TO_VARCHAR(DBT_VALID_FROM, 'YYYY-MM-DD HH24:MI:SS.FF9')
        ),
        256
    ) AS PRICE_KEY,

    LISTING_ID,
    PRICE_PER_NIGHT,

    DBT_VALID_FROM AS VALID_FROM,
    DBT_VALID_TO AS VALID_TO,

    CASE
        WHEN DBT_VALID_TO IS NULL THEN TRUE
        ELSE FALSE
    END AS IS_CURRENT

FROM {{ ref('scd_listings') }}


{{
    config(
        materialized='table',
        schema='gold_dim'
    )
}}
----SHA2(CONCAT(TO_VARCHAR(LISTING_ID),
    --'|',TO_VARCHAR(DBT_VALID_FROM, 'YYYY-MM-DD HH24:MI:SS.FF9')),256) AS LISTING_KEY,
SELECT
    {{ dbt_utils.generate_surrogate_key([      
        'LISTING_ID',  
        'DBT_VALID_FROM'
    ]) }} AS LISTING_KEY,

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

    DBT_VALID_FROM AS VALID_FROM,
    DBT_VALID_TO AS VALID_TO,

    CASE
        WHEN DBT_VALID_TO IS NULL THEN TRUE
        ELSE FALSE
    END AS IS_CURRENT

FROM {{ ref('scd_listings') }}

--SHA2(CONCAT(TO_VARCHAR(LISTING_ID),
    --'|',TO_VARCHAR(DBT_VALID_FROM, 'YYYY-MM-DD HH24:MI:SS.FF9')),256) AS LISTING_KEY,


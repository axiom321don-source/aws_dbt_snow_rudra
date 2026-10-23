
{{
    config(
        materialized='table',
        schema='gold_dim'
    )
}}

SELECT
    {{ dbt_utils.generate_surrogate_key([
        'HOST_ID',
        'DBT_VALID_FROM'
    ]) }} AS HOST_KEY,

    HOST_ID,
    HOST_NAME,
    IS_SUPERHOST,
    RESPONSE_RATE,
    DBT_VALID_FROM AS VALID_FROM,
    DBT_VALID_TO AS VALID_TO,

    CASE
        WHEN DBT_VALID_TO IS NULL THEN TRUE
        ELSE FALSE
    END AS IS_CURRENT

FROM {{ ref('scd_hosts') }}

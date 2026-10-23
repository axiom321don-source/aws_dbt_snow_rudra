
{{
    config(
        materialized='incremental',
        unique_key='HOST_ID',
        schema='silver',
        on_schema_change='append_new_columns'
    )
}}

SELECT
    *,
    DAY(HOST_SINCE) AS HOST_SINCE_DAY,
    MONTHNAME(HOST_SINCE) AS HOST_SINCE_MONTH,
    YEAR(HOST_SINCE) AS HOST_SINCE_YEAR,

    CASE
        WHEN RESPONSE_RATE IS NULL
            OR RESPONSE_RATE < 0
            OR RESPONSE_RATE > 100
            THEN 'UNKNOWN'
        WHEN RESPONSE_RATE >= 90 THEN 'EXCELLENT'
        WHEN RESPONSE_RATE >= 75 THEN 'GOOD'
        WHEN RESPONSE_RATE >= 50 THEN 'MODERATE'
        ELSE 'LOW'
    END AS RESPONSE_RATE_CATEGORY

FROM {{ ref('hosts') }}

{% if is_incremental() %}
    WHERE DBT_LOADED_AT >= (
        SELECT COALESCE(
            MAX(DBT_LOADED_AT),
            '1900-01-01'::TIMESTAMP_NTZ
        )
        FROM {{ this }}
    )
{% endif %}
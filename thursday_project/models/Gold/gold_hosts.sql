{{
    config
        (materialized='table',
        schema='gold')
    
}}

    SELECT
        HOST_ID,
        HOST_NAME,
        HOST_SINCE,
        HOST_SINCE_DAY,
        HOST_SINCE_MONTH,
        HOST_SINCE_YEAR,
        IS_SUPERHOST,
        RESPONSE_RATE,
        RESPONSE_RATE_CATEGORY,
        DATEDIFF('day',HOST_SINCE,CURRENT_DATE()) AS HOST_TENURE_DAY,
        CREATED_AT
    FROM 
        {{ ref('s_hosts') }}

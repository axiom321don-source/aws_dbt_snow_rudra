
{% snapshot scd_hosts %}

{{
    config(
        target_schema='snapshots',
        unique_key='HOST_ID',
        strategy='check',
        check_cols=[
            'HOST_NAME',
            'IS_SUPERHOST',
            'RESPONSE_RATE'
        ]
    )
}}

SELECT *
FROM {{ source('source', 'HOSTS') }}

{% endsnapshot %}

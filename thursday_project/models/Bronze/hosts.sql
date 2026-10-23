SELECT
    *,
    CURRENT_TIMESTAMP() AS dbt_loaded_at,
    CURRENT_USER()      AS dbt_loaded_by,
    CURRENT_ROLE() AS dbt_loaded_by_role
FROM
   {{ source('source', 'HOSTS') }}
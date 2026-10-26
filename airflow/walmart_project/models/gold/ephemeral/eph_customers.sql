SELECT
    DISTINCT
    customer_dimension_id,
    first_name,
    last_name,
    email,
    phone,
    city,
    province,
    country,
    customer_created_timestamp,
    customer_updated_timestamp,
    customer_is_active,
    customer_processed_at,
    current_timestamp() AS customer_gold_processed_at
FROM {{ ref("obt_b") }} AS obt

SELECT
    DISTINCT
    product_dimension_id,
    product_name,
    product_price,
    category,
    brand,
    product_created_timestamp,
    product_updated_timestamp,
    product_is_active,
    product_processed_at
FROM {{ ref("obt_b") }} AS obt
    
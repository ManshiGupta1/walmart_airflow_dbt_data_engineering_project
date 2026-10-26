{{ config(severity="warn") }}

SELECT 1
FROM {{ ref("obt_b") }} AS obt
WHERE
    obt.order_id IS NULL
    OR obt.customer_dimension_id IS NULL
    OR obt.store_dimension_id IS NULL
    OR obt.employee_id IS NULL
    OR obt.product_dimension_id IS NULL
    OR obt.order_item_id IS NULL
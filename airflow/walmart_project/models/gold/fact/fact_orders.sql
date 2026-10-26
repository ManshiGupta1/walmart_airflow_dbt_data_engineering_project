select
    order_id,
    order_item_id,
    product_dimension_id,
    customer_dimension_id,
    store_dimension_id,
    employee_id,
    total_amount,
    quantity,
    unit_price,
    line_amount
from {{ ref('obt_b') }} 
{% set configs = [
    {
        "table_name": "walmart.silver_tech.orders_t",
        "columns": """o.order_id,
                        o.store_id AS order_store_id,
                        o.order_timestamp,
                        o.payment_method,
                        o.customer_id AS order_customer_id,
                        o.order_status,
                        o.total_amount,
                        o.created_timestamp AS order_created_timestamp,
                        o.updated_timestamp AS order_updated_timestamp,
                        o.is_active AS order_is_active,
                        o.processed_at AS order_processed_at
                   """,
        "alias": "o",
              

    },
    {
        "table_name": "walmart.silver_tech.order_items_t",
        "columns": """oi.order_item_id,
                        oi.order_id AS item_order_id,
                        oi.product_id AS item_product_id,
                        oi.quantity,
                        oi.unit_price,
                        oi.line_amount,
                        oi.created_timestamp AS order_item_created_timestamp,
                        oi.updated_timestamp AS order_item_updated_timestamp,
                        oi.is_active AS order_item_is_active,
                        oi.processed_at AS order_item_processed_at
                   """,
        "alias": "oi",
        "join_condition": "o.order_id = oi.order_id"
    },
    {
        "table_name": "walmart.silver_tech.products_t",
        "columns": """p.product_id AS product_dimension_id,
                        p.product_name,
                        p.category,
                        p.brand,
                        p.price AS product_price,
                        p.created_timestamp AS product_created_timestamp,
                        p.updated_timestamp AS product_updated_timestamp,
                        p.is_active AS product_is_active,
                        p.processed_at AS product_processed_at
                   """,
        "alias": "p",
        "join_condition": "oi.product_id = p.product_id"
    },
    {
        "table_name": "walmart.silver_tech.customers_t",
        "columns": """c.customer_id AS customer_dimension_id,
                        c.first_name,
                        c.last_name,
                        c.email,
                        c.phone,
                        c.city,
                        c.province,
                        c.country,
                        c.created_timestamp AS customer_created_timestamp,
                        c.updated_timestamp AS customer_updated_timestamp,
                        c.is_active AS customer_is_active,
                        c.processed_at AS customer_processed_at
                   """,
        "alias": "c",
        "join_condition": "o.customer_id = c.customer_id"
    },
    {
        "table_name": "walmart.silver_tech.stores_t",
        "columns": """s.store_id AS store_dimension_id,
                        s.store_name,
                        s.city AS store_city,
                        s.province AS store_province,
                        s.country AS store_country,
                        s.created_timestamp AS store_created_timestamp,
                        s.updated_timestamp AS store_updated_timestamp,
                        s.is_active AS store_is_active,
                        s.processed_at AS store_processed_at
                   """,
        "alias": "s",
        "join_condition": "o.store_id = s.store_id"
    },
    {
        "table_name": "walmart.silver_tech.employees_t",
        "columns": """e.employee_id,

                        e.first_name AS employee_first_name,
                        e.store_id AS employee_store_id,
                        e.last_name AS employee_last_name,
                        e.email AS employee_email,
                        e.job_title AS employee_job_title,
                        e.salary AS employee_salary,
                        e.created_timestamp AS employee_created_timestamp,
                        e.updated_timestamp AS employee_updated_timestamp,
                        e.is_active AS employee_is_active,
                        e.processed_at AS employee_processed_at
                   """,
        "alias": "e",
        "join_condition": "o.store_id = e.store_id"
    }
    
] %}


SELECT
    {% for config in configs %}
        {{ config["columns"] }}
        {% if not loop.last %},{% endif %}
    {% endfor %}

FROM
    {% for config in configs %}
        {% if loop.first %}
            {{ config["table_name"] }} AS {{ config["alias"] }}
        {% else %}
            LEFT JOIN {{ config["table_name"] }} AS {{ config["alias"] }}
                ON {{ config["join_condition"] }}
        {% endif %}
    {% endfor %}

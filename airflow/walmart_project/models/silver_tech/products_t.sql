{{
    config(
        materialized='incremental',
    
    )
}}

select
*,
current_timestamp() as processed_at
from

{{ source('walmart_databricks', 'products') }}



{% if is_incremental() %}
    WHERE updated_timestamp > (select coalesce(max(updated_timestamp), '1900-01-01') from {{ this }})
{% endif %}
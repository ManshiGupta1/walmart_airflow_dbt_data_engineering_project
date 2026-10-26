
SELECT *
FROM {{ ref('customers_t') }}
WHERE phone IS NOT NULL
  AND (
    LENGTH(
      REGEXP_REPLACE(
        SPLIT(phone, 'x')[0],
        '[^0-9]',
        ''
      )
    ) < 7
    OR LENGTH(
      REGEXP_REPLACE(
        SPLIT(phone, 'x')[0],
        '[^0-9]',
        ''
      )
    ) > 15
  )

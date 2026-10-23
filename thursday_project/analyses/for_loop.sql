{% set cols =  ['BOOKING_AMOUNT' , 'CLEANING_FEE' , 'SERVICE_FEE'] %}

SELECT
  BOOKING_ID,
  {% for col in cols %}
    MAX({{col}}) AS maximum_{{ col | lower}},
    AVG({{col}}) AS average_{{ col | lower}},
    MIN({{col}}) AS minimum_{{ col | lower}}
    {% if not loop.last%},{%endif%}
  {% endfor %} 
FROM 
  {{ ref('bookings') }}
GROUP BY  BOOKING_ID
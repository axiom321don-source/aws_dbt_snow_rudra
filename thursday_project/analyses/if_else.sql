{% set flag = 5 %}

select * from {{ ref('bookings') }}

{% if flag == 1  %}
  WHERE NIGHTS_BOOKED > 1
{% else %}
  WHERE NIGHTS_BOOKED = 6
{% endif %}  
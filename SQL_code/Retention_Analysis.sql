WITH customer_revenue AS(	
	SELECT
		s.customerkey, 
		s.orderdate,
		sum(s.quantity * s.netprice * s.exchangerate) AS total_revenue,
		count(s.orderkey) AS num_orders,
		c.countryfull,
		c.age,
		c.givenname,
		c.surname
	FROM
		sales s
	LEFT JOIN customer c ON
		c.customerkey = s.customerkey
	GROUP BY 
		s.customerkey ,
		s.orderdate,
		c.countryfull,
		c.age,
		c.givenname,
		c.surname
),purchasing_behavior AS (
SELECT
	cr. *,
	 min(cr.orderdate) OVER(PARTITION BY cr.customerkey) AS first_purchase_date,
	 EXTRACT(YEAR FROM min(cr.orderdate) OVER(PARTITION BY cr.customerkey)) AS cohort_year
FROM
	customer_revenue cr
), customer_last_purchase as(
SELECT
    customerkey,
    givenname,
    orderdate,
    row_number() OVER(PARTITION BY customerkey ORDER BY orderdate desc)  AS purchase_number,
    first_purchase_date,
    max(orderdate) over() as max_purchase_date
FROM 
    purchasing_behavior
)
SELECT
    customerkey,
    givenname,
    extract(year from first_purchase_date) as cohort_year,
    orderdate as last_purchase_date,
    case 
        when orderdate < max_purchase_date - INTERVAL '6 month' then 'churned'
        else 'active'
        end as customer_status
from 
    customer_last_purchase
WHERE 
    purchase_number = 1 
    and first_purchase_date < max_purchase_date - INTERVAL '6 month'



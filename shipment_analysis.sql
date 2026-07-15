-- ============================================================
-- Logistics Shipment Delay & Cost Analysis
-- Dataset: shipments_dataset.csv (1500 shipment records)
-- ============================================================

-- Query 1: View sample data
SELECT * FROM shipments_dataset LIMIT 10;

-- Query 2: Filter delayed shipments
SELECT * FROM shipments_dataset WHERE status = 'Delayed' LIMIT 10;

-- Query 3: Count of delayed shipments per customer
SELECT customer_name, COUNT(*) AS delayed_count
FROM shipments_dataset
WHERE status = 'Delayed'
GROUP BY customer_name
ORDER BY delayed_count DESC;

-- Query 4: Transit time per shipment (in days)
SELECT shipment_id, customer_name, shipment_date, delivery_date,
       JULIANDAY(delivery_date) - JULIANDAY(shipment_date) AS transit_days
FROM shipments_dataset
WHERE status = 'Delivered'
LIMIT 15;

-- Query 5: Average transit time per customer
SELECT customer_name,
       ROUND(AVG(JULIANDAY(delivery_date) - JULIANDAY(shipment_date)), 1) AS avg_transit_days,
       COUNT(*) AS total_shipments
FROM shipments_dataset
WHERE status = 'Delivered'
GROUP BY customer_name
ORDER BY avg_transit_days DESC;

-- Query 6: Slowest lanes (origin-destination pairs), min 5 shipments
SELECT origin_city, destination_city,
       ROUND(AVG(JULIANDAY(delivery_date) - JULIANDAY(shipment_date)), 1) AS avg_transit_days,
       COUNT(*) AS total_shipments
FROM shipments_dataset
WHERE status = 'Delivered'
GROUP BY origin_city, destination_city
HAVING COUNT(*) >= 5
ORDER BY avg_transit_days DESC
LIMIT 10;

-- Query 7: Delay rate % per customer
SELECT customer_name,
       COUNT(*) AS total_shipments,
       SUM(CASE WHEN status = 'Delayed' THEN 1 ELSE 0 END) AS delayed_shipments,
       ROUND(100.0 * SUM(CASE WHEN status = 'Delayed' THEN 1 ELSE 0 END) / COUNT(*), 1) AS delay_rate_pct
FROM shipments_dataset
GROUP BY customer_name
ORDER BY delay_rate_pct DESC;

-- Query 8: Revenue and average cost by service type
SELECT service_type,
       COUNT(*) AS total_shipments,
       ROUND(AVG(cost_inr), 2) AS avg_cost,
       ROUND(SUM(cost_inr), 2) AS total_revenue
FROM shipments_dataset
GROUP BY service_type
ORDER BY total_revenue DESC;

-- Query 9: Rank customers by total shipment volume (window function)
SELECT customer_name,
       COUNT(*) AS total_shipments,
       RANK() OVER (ORDER BY COUNT(*) DESC) AS volume_rank
FROM shipments_dataset
GROUP BY customer_name;

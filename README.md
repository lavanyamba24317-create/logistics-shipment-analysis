# Logistics Shipment Delay & Cost Analysis

## Business Question
Which customers and shipping lanes experience the most delivery delays, and how do service types compare on cost and revenue? This analysis was inspired by real-world logistics operations in the healthcare supply chain space, where turnaround time (TAT) and delay tracking directly affect customer retention and revenue.

## Dataset
1,500 simulated shipment records with the following fields: shipment ID, customer name, origin/destination city, service type (NFO, HC GOLD, HC SILVER), weight, shipment/delivery dates, cost, and status (Delivered, Delayed, In Transit).

## Tools Used
SQL (SQLite) for querying and analysis.

## Key Findings

1. **Customer delay patterns differ by metric.** Suraksha Diagnostics has the slowest average transit time (~3.5 days), while Healthians has the highest delay *rate* (% of shipments delayed) — showing these are two distinct problems: general slowness vs. inconsistency.

2. **Hyderabad → Kolkata is the slowest lane** among routes with meaningful volume (5+ shipments), flagging it as a route worth operational review — though the sample size here is small and would benefit from more data.

3. **Service type revenue vs. cost tradeoff:** NFO drives the highest total revenue due to volume, while HC GOLD has the highest average cost per shipment, indicating it functions as the premium/high-margin service line.

4. Customers were ranked by total shipment volume using a SQL window function (`RANK()`), identifying the highest-volume accounts for prioritization.

## Queries
All SQL queries are available in [`shipment_analysis.sql`](./shipment_analysis.sql), covering filtering, aggregation (GROUP BY, COUNT, AVG, SUM), conditional logic (CASE), having clauses, and window functions (RANK).

## Next Steps
- Expand analysis with Python/Power BI visualizations of delay trends over time
- Add cohort-style analysis of repeat delay customers
- Incorporate CTEs and subqueries for more advanced lane-level comparisons

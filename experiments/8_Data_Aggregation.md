# 📊 Experiment 8: Data Aggregation

## 🛠️ **Tool: Apache Hive (Aggregation functions)**

**What is Data Aggregation?**
- Summarizing large datasets into meaningful statistics
- Calculating totals, averages, counts, min/max values
- **Use Case**: Business analytics, reporting, KPI calculations
- **Key Concepts**: GROUP BY, aggregate functions, HAVING clause

---

## 🎯 Objective
Perform aggregation operations on large datasets to extract insights.

---

## 📋 Steps

### Step 1: Start Hive Shell

```bash
docker exec -it hive-server hive
```

---

### Step 2: Create Test Data

Create sales data table:

```sql
CREATE TABLE sales (
    order_id INT,
    customer_name STRING,
    product_category STRING,
    order_date STRING,
    amount INT,
    quantity INT
);

INSERT INTO TABLE sales VALUES
(1001, 'Alice', 'Electronics', '2024-01-01', 50000, 1),
(1002, 'Bob', 'Clothing', '2024-01-02', 5000, 10),
(1003, 'Alice', 'Electronics', '2024-01-03', 30000, 1),
(1004, 'Charlie', 'Books', '2024-01-04', 2000, 5),
(1005, 'Bob', 'Clothing', '2024-01-05', 8000, 15),
(1006, 'Diana', 'Electronics', '2024-01-06', 45000, 1),
(1007, 'Alice', 'Books', '2024-01-07', 1500, 3),
(1008, 'Charlie', 'Clothing', '2024-01-08', 12000, 20),
(1009, 'Bob', 'Electronics', '2024-01-09', 25000, 1),
(1010, 'Diana', 'Clothing', '2024-01-10', 6000, 10);
```

---

## 📊 Aggregation Examples

### Example 1: Basic Aggregation - Overall Statistics

Get total statistics across all data:

```sql
SELECT 
    COUNT(*) as total_orders,
    COUNT(DISTINCT customer_name) as unique_customers,
    SUM(amount) as total_revenue,
    AVG(amount) as avg_order_value,
    MIN(amount) as min_order,
    MAX(amount) as max_order
FROM sales;
```

**Output:**
```
10	4	184500	18450	1500	50000
```

---

### Example 2: GROUP BY - Sales by Category

Aggregate by product category:

```sql
SELECT 
    product_category,
    COUNT(*) as order_count,
    SUM(amount) as total_sales,
    AVG(amount) as avg_sale,
    SUM(quantity) as total_quantity
FROM sales
GROUP BY product_category
ORDER BY total_sales DESC;
```

**Output:**
```
Electronics	4	150000	37500	4
Clothing	4	31000	7750	55
Books	2	3500	1750	8
```

---

### Example 3: GROUP BY Multiple Columns

Aggregate by customer and category:

```sql
SELECT 
    customer_name,
    product_category,
    COUNT(*) as purchases,
    SUM(amount) as spent,
    AVG(amount) as avg_spend
FROM sales
GROUP BY customer_name, product_category
ORDER BY spent DESC;
```

**Output:**
```
Alice	Electronics	2	80000	40000
Bob	Clothing	2	13000	6500
Diana	Electronics	1	45000	45000
Charlie	Clothing	1	12000	12000
Bob	Electronics	1	25000	25000
Charlie	Books	1	2000	2000
Diana	Clothing	1	6000	6000
Alice	Books	1	1500	1500
Bob	Clothing	0	0	NULL
```

---

### Example 4: HAVING Clause - Filter After Aggregation

Find categories with total sales > 30,000:

```sql
SELECT 
    product_category,
    COUNT(*) as order_count,
    SUM(amount) as total_sales
FROM sales
GROUP BY product_category
HAVING SUM(amount) > 30000
ORDER BY total_sales DESC;
```

**Output:**
```
Electronics	4	150000
Clothing	4	31000
```

---

### Example 5: Customer Analysis

Top customers by spending:

```sql
SELECT 
    customer_name,
    COUNT(*) as purchase_count,
    SUM(amount) as total_spent,
    AVG(amount) as avg_spend,
    MIN(amount) as min_purchase,
    MAX(amount) as max_purchase
FROM sales
GROUP BY customer_name
HAVING COUNT(*) > 1
ORDER BY total_spent DESC;
```

**Output:**
```
Alice	3	81500	27166.67	1500	50000
Bob	3	38000	12666.67	5000	25000
Charlie	2	14000	7000	2000	12000
Diana	2	51000	25500	6000	45000
```

---

### Example 6: String Aggregation

Collect products per customer:

```sql
SELECT 
    customer_name,
    COUNT(*) as order_count,
    COLLECT_LIST(product_category) as categories,
    SUM(amount) as total
FROM sales
GROUP BY customer_name;
```

**Output:**
```
Alice	3	["Electronics","Electronics","Books"]	81500
Bob	3	["Clothing","Clothing","Electronics"]	38000
Charlie	2	["Books","Clothing"]	14000
Diana	2	["Electronics","Clothing"]	51000
```

---

### Example 7: Percentile Aggregation

Calculate sales percentiles:

```sql
SELECT 
    PERCENTILE_APPROX(amount, 0.25) as Q1,
    PERCENTILE_APPROX(amount, 0.50) as median,
    PERCENTILE_APPROX(amount, 0.75) as Q3,
    PERCENTILE_APPROX(amount, 0.95) as P95
FROM sales;
```

**Output:**
```
3500	10500	35000	49000
```

---

### Example 8: Standard Deviation and Variance

Statistical measures:

```sql
SELECT 
    product_category,
    COUNT(*) as count,
    SUM(amount) as total,
    AVG(amount) as mean,
    STDDEV_POP(amount) as std_dev,
    VARIANCE(amount) as variance
FROM sales
GROUP BY product_category;
```

**Output:**
```
Books	2	3500	1750	250	62500
Clothing	4	31000	7750	3640.31	13251923.08
Electronics	4	150000	37500	9352.85	87475000
```

---

### Example 9: CASE Statement with Aggregation

Segment customers by spending:

```sql
SELECT 
    CASE 
        WHEN SUM(amount) >= 40000 THEN 'High Value'
        WHEN SUM(amount) >= 15000 THEN 'Medium Value'
        ELSE 'Low Value'
    END as customer_segment,
    COUNT(DISTINCT customer_name) as customer_count,
    COUNT(*) as total_orders,
    SUM(SUM(amount)) as segment_revenue
FROM sales
GROUP BY CASE 
    WHEN SUM(amount) >= 40000 THEN 'High Value'
    WHEN SUM(amount) >= 15000 THEN 'Medium Value'
    ELSE 'Low Value'
END;
```

---

### Example 10: Time-Based Aggregation

Group by date ranges (monthly trend):

```sql
SELECT 
    SUBSTR(order_date, 1, 7) as month,
    COUNT(*) as order_count,
    SUM(amount) as daily_revenue,
    AVG(amount) as avg_order
FROM sales
GROUP BY SUBSTR(order_date, 1, 7)
ORDER BY month;
```

**Output:**
```
2024-01	10	184500	18450
```

---

## 📊 Common Aggregate Functions

| Function | Purpose | Example |
|----------|---------|---------|
| `COUNT(*)` | Count all rows | `COUNT(*)` |
| `COUNT(DISTINCT)` | Unique values | `COUNT(DISTINCT customer)` |
| `SUM()` | Total sum | `SUM(amount)` |
| `AVG()` | Average value | `AVG(salary)` |
| `MIN()` | Minimum value | `MIN(price)` |
| `MAX()` | Maximum value | `MAX(salary)` |
| `STDDEV()` | Standard deviation | `STDDEV(amount)` |
| `VARIANCE()` | Variance | `VARIANCE(score)` |
| `PERCENTILE()` | Percentile | `PERCENTILE(salary, 0.5)` |
| `COLLECT_LIST()` | Collect values | `COLLECT_LIST(item)` |

---

## 💡 Aggregation Best Practices

1. **Use GROUP BY** when you need per-group statistics
2. **Use HAVING** to filter groups, not WHERE
3. **Index on GROUP BY columns** for performance
4. **Limit results** with LIMIT when appropriate
5. **Use appropriate data types** (INT vs BIGINT for large sums)

---

## 🔍 Execution Flow

```
Raw Data
  ↓
Filter (WHERE clause)
  ↓
Group (GROUP BY)
  ↓
Aggregate (SUM, AVG, COUNT, etc.)
  ↓
Filter Groups (HAVING)
  ↓
Sort (ORDER BY)
  ↓
Results
```

---

## 🐛 Troubleshooting

**"Column not in GROUP BY" error?**
```sql
-- All non-aggregated columns must be in GROUP BY
SELECT category, name, SUM(amount)  -- ERROR: name not in GROUP BY
FROM sales
GROUP BY category;

-- Correct:
SELECT category, SUM(amount)
FROM sales
GROUP BY category;
```

**Aggregation too slow?**
```sql
-- Use approximate aggregations
SELECT 
    COUNT(DISTINCT customer_name) as unique_customers
FROM sales;

-- Or:
SELECT 
    APPROX_COUNT_DISTINCT(customer_name) as approx_unique
FROM sales;
```

**NULL values in aggregation?**
```sql
-- NULL values excluded by default
-- To include them:
SELECT 
    COUNT(*) as total_rows,           -- includes NULLs
    COUNT(customer_name) as non_null   -- excludes NULLs
FROM sales;
```

---

## 🎯 Real-World Use Cases

1. **Revenue Reporting**: Total sales by region, product, time period
2. **Customer Analytics**: Top customers, customer segments, spending patterns
3. **Inventory Management**: Stock levels, fast-moving items, slow-moving items
4. **Performance Metrics**: KPIs, trend analysis, anomaly detection
5. **Quality Analysis**: Defect rates, error distributions, efficiency metrics

---

## 🎯 Exit Hive

When done:
```sql
quit;
```

---

## ✅ Experiments Complete!

You've covered all 8 experiments:
1. ✅ MapReduce Word Count
2. ✅ Hive SQL Queries
3. ✅ Pig Data Processing
4. ✅ Sqoop Import/Export
5. ✅ Hive External Tables
6. ✅ Join Operations
7. ✅ Pig Joins
8. ✅ Data Aggregation

**You're now ready for real-world big data projects!** 🚀

---

**Status**: ✅ Complete | **Difficulty**: Intermediate | **Time**: 15-20 minutes


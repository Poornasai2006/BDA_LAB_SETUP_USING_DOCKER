# 📋 Experiment 5: Hive External Tables

## 🛠️ **Tool: Apache Hive (External Tables)**

**What are External Tables?**
- Hive tables that reference data in HDFS instead of managed tables
- Data stored outside Hive metastore
- **Use Case**: Query existing HDFS files without copying them, easier data sharing
- **Key Concepts**: EXTERNAL keyword, LOCATION clause, table metadata

---

## 🎯 Objective
Create external Hive tables pointing to HDFS data and query them.

---

## 📋 Steps

### Step 1: Create Sample Data File

```bash
# Create CSV file
cat > /tmp/products.csv << 'EOF'
1,Laptop,50000
2,Mouse,500
3,Keyboard,1000
4,Monitor,15000
5,Headphones,2000
EOF
```

### Step 2: Access NameNode Terminal

```bash
docker exec -it namenode bash
```

### Step 3: Put Data in HDFS

```bash
# Copy to container
cp /tmp/products.csv /tmp/

# Create HDFS directory
hadoop fs -mkdir -p /data

# Put file in HDFS
hadoop fs -put /tmp/products.csv /data/products.csv

# Verify
hadoop fs -ls /data
hadoop fs -cat /data/products.csv
```

---

### Step 4: Create External Table in Hive

Exit the NameNode terminal:
```bash
exit
```

Start Hive:
```bash
docker exec -it hive-server hive
```

Create external table:
```sql
CREATE EXTERNAL TABLE products (
    id INT,
    name STRING,
    price INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LOCATION '/data';
```

**Note**: The `EXTERNAL` keyword tells Hive this is external data, not managed by Hive. The `LOCATION` clause points to the HDFS directory.

---

### Step 5: Query the External Table

```sql
-- View all products
SELECT * FROM products;
```

**Expected Output:**
```
1	Laptop	50000
2	Mouse	500
3	Keyboard	1000
4	Monitor	15000
5	Headphones	2000
```

---

### Query 1: Filter Products

```sql
SELECT name, price FROM products WHERE price > 1000;
```

**Output:**
```
Laptop	50000
Keyboard	1000
Monitor	15000
```

---

### Query 2: Sort and Limit

```sql
SELECT name, price FROM products 
ORDER BY price DESC 
LIMIT 3;
```

**Output:**
```
Laptop	50000
Monitor	15000
Headphones	2000
```

---

### Query 3: Aggregate Functions

```sql
SELECT 
    COUNT(*) as total_products,
    AVG(price) as avg_price,
    MIN(price) as min_price,
    MAX(price) as max_price,
    SUM(price) as total_value
FROM products;
```

**Output:**
```
5	13500	500	50000	67500
```

---

### Query 4: Price Categories

```sql
SELECT 
    CASE 
        WHEN price < 1000 THEN 'Budget'
        WHEN price < 10000 THEN 'Mid-range'
        ELSE 'Premium'
    END as category,
    COUNT(*) as count,
    AVG(price) as avg_price
FROM products
GROUP BY CASE 
    WHEN price < 1000 THEN 'Budget'
    WHEN price < 10000 THEN 'Mid-range'
    ELSE 'Premium'
END;
```

**Output:**
```
Budget	2	750
Mid-range	1	1000
Premium	2	32500
```

---

### Step 6: Add More Data (Demonstrates EXTERNAL advantage)

Exit Hive:
```sql
quit;
```

Add more data in HDFS (don't need to recreate table!):

```bash
# Back in NameNode terminal
docker exec -it namenode bash

# Create another data file
cat > /tmp/more_products.csv << 'EOF'
6,Tablet,25000
7,Speaker,5000
EOF

# Append to HDFS directory
hadoop fs -put /tmp/more_products.csv /data/more_products.csv

# View all files in /data
hadoop fs -ls /data

exit
```

---

### Step 7: Query Updated Data

Start Hive again:

```bash
docker exec -it hive-server hive
```

Query the same table (Hive automatically sees new files!):

```sql
SELECT * FROM products;
```

**New Output** (includes appended data):
```
1	Laptop	50000
2	Mouse	500
3	Keyboard	1000
4	Monitor	15000
5	Headphones	2000
6	Tablet	25000
7	Speaker	5000
```

No need to recreate the table! This is the power of external tables.

---

## 📊 Managed vs External Tables

| Feature | Managed | External |
|---------|---------|----------|
| Data Location | Hive warehouse | User-specified (HDFS) |
| Drop Table | Deletes data | Keeps data |
| Data Sharing | Difficult | Easy |
| Performance | Slightly faster | Slightly slower |
| Use Case | Internal processing | Shared data |

---

## 🔍 External Table Advantages

```
Traditional (Managed):
    Data → Copy to Hive → Query
         ↓
    Multiple copies (disk waste)

External:
    Data in HDFS → Query directly
         ↓
    Single copy (efficient)
```

---

## 💡 Learning Points

- ✅ Difference between managed and external tables
- ✅ Creating external tables pointing to HDFS
- ✅ Querying without data duplication
- ✅ Dynamic data discovery
- ✅ Data sharing benefits

---

## 🐛 Troubleshooting

**Table shows no data?**
```sql
-- Verify table definition
DESCRIBE products;

-- Check if location is correct
SHOW TBLPROPERTIES products;

-- Manually refresh metadata
MSCK REPAIR TABLE products;
```

**LOCATION path not found?**
```bash
# Check if HDFS path exists and has data
docker exec namenode hadoop fs -ls /data
docker exec namenode hadoop fs -cat /data/*
```

**Cannot create table (already exists)?**
```sql
-- Drop the table (data stays in HDFS!)
DROP TABLE IF EXISTS products;

-- Recreate it
CREATE EXTERNAL TABLE products ...
```

---

## 🎯 Advanced Example: Multiple File Formats

Create external table for Parquet files:

```sql
CREATE EXTERNAL TABLE products_parquet (
    id INT,
    name STRING,
    price INT
)
STORED AS PARQUET
LOCATION '/data/parquet';
```

Or for JSON:

```sql
CREATE EXTERNAL TABLE products_json (
    id INT,
    name STRING,
    price INT
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe'
LOCATION '/data/json';
```

---

## 🎯 Next Experiment

Ready for more? Try **Experiment 6: Join Operations** to combine multiple tables!

---

**Status**: ✅ Complete | **Difficulty**: Intermediate | **Time**: 15-20 minutes


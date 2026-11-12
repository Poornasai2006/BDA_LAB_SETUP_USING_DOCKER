# 🐷 Experiment 3: Pig Data Processing

## 🛠️ **Tool: Apache Pig**

**What is Pig?**
- Procedural programming language for Hadoop data processing
- Converts Pig Latin scripts to MapReduce jobs
- **Use Case**: Complex ETL (Extract, Transform, Load) operations without writing Java
- **Key Concepts**: LOAD, FILTER, GROUP, FOREACH, STORE operations

---

## 🎯 Objective
Use Pig to process and transform data using scripts.

---

## 📋 Steps

### Step 1: Create Sample Data

```bash
# Create input data
cat > /tmp/sales.txt << 'EOF'
2024-01-01,100,Product A
2024-01-02,150,Product B
2024-01-03,200,Product A
2024-01-04,120,Product C
2024-01-05,180,Product B
EOF
```

### Step 2: Access NameNode Terminal

```bash
docker exec -it namenode bash
```

### Step 3: Put Data in HDFS

```bash
# Copy to container tmp
cp /tmp/sales.txt /tmp/

# Put in HDFS
hadoop fs -put /tmp/sales.txt /sales.txt

# Verify
hadoop fs -cat /sales.txt
```

---

### Step 4: Create Pig Script

```bash
cat > /tmp/sales_analysis.pig << 'EOF'
-- Load data
sales_data = LOAD '/sales.txt' USING PigStorage(',') 
    AS (date:chararray, amount:int, product:chararray);

-- Filter data (amount > 100)
high_sales = FILTER sales_data BY amount > 100;

-- Group by product
grouped = GROUP high_sales BY product;

-- Calculate totals
product_totals = FOREACH grouped GENERATE 
    group as product, 
    SUM(high_sales.amount) as total_sales;

-- Store results
STORE product_totals INTO '/pig_output' USING PigStorage(',');
EOF
```

---

### Step 5: Run Pig Script (Non-Interactive)

```bash
# Execute script directly
pig -f /tmp/sales_analysis.pig
```

**Output** (in logs):
```
Successfully stored result in directory /pig_output
```

---

### Step 6: View Results

```bash
# Check if output directory exists
hadoop fs -ls /pig_output

# View the results
hadoop fs -cat /pig_output/*
```

**Expected Output:**
```
Product A,300
Product B,330
Product C,120
```

---

## 🔄 Interactive Pig Shell (Alternative)

```bash
# Start Pig shell (interactive mode)
pig
```

You'll see the Grunt prompt:
```
grunt>
```

### Run Commands Interactively

```pig
grunt> sales_data = LOAD '/sales.txt' USING PigStorage(',') 
            AS (date:chararray, amount:int, product:chararray);
grunt> high_sales = FILTER sales_data BY amount > 100;
grunt> grouped = GROUP high_sales BY product;
grunt> product_totals = FOREACH grouped GENERATE 
            group as product, 
            SUM(high_sales.amount) as total_sales;
grunt> DUMP product_totals;
```

**Output:**
```
(Product A,300)
(Product B,330)
(Product C,120)
```

Exit Pig shell:
```
grunt> quit;
```

---

## 📝 Pig Latin Syntax Explained

| Command | Purpose | Example |
|---------|---------|---------|
| `LOAD` | Load data from file | `LOAD '/file.txt'` |
| `FILTER` | Filter rows by condition | `FILTER data BY amount > 100` |
| `GROUP` | Group by field | `GROUP data BY product` |
| `FOREACH` | Transform each row | `FOREACH data GENERATE field1, field2` |
| `STORE` | Save results to file | `STORE result INTO '/output'` |
| `JOIN` | Join datasets | `JOIN data1 BY id, data2 BY id` |
| `ORDER` | Sort data | `ORDER data BY amount DESC` |
| `DISTINCT` | Remove duplicates | `DISTINCT data` |
| `SUM()`, `COUNT()` | Aggregate functions | `SUM(amount)` |

---

## 🔍 Data Transformation Flow

```
Input CSV:
2024-01-01,100,Product A
2024-01-02,150,Product B
2024-01-03,200,Product A
2024-01-04,120,Product C
2024-01-05,180,Product B

After LOAD:
(2024-01-01, 100, Product A)
(2024-01-02, 150, Product B)
...

After FILTER (amount > 100):
(2024-01-02, 150, Product B)
(2024-01-03, 200, Product A)
(2024-01-05, 180, Product B)
(2024-01-04, 120, Product C)

After GROUP BY product:
(Product A): [(200)]
(Product B): [(150), (180)]
(Product C): [(120)]

After SUM:
(Product A, 200)
(Product B, 330)
(Product C, 120)

Final Output:
Product A,200
Product B,330
Product C,120
```

---

## 💡 Learning Points

- ✅ Pig Latin syntax
- ✅ Data loading and storage
- ✅ Filtering and transformations
- ✅ Grouping and aggregation
- ✅ How Pig converts to MapReduce
- ✅ Interactive vs batch mode

---

## 🐛 Troubleshooting

**Script not found?**
```bash
# Check if file exists
ls -la /tmp/sales_analysis.pig

# Check HDFS input file
hadoop fs -cat /sales.txt
```

**Output directory already exists?**
```bash
# Remove output directory
hadoop fs -rm -r /pig_output

# Then run script again
pig -f /tmp/sales_analysis.pig
```

**Pig shell not starting?**
```bash
# Check if Hadoop is running
hadoop dfsadmin -report

# Check Pig installation
pig -version

# Try accessing NameNode again
docker exec -it namenode bash
```

---

## 🎯 More Complex Example

Create a script with multiple transformations:

```bash
cat > /tmp/advanced_pig.pig << 'EOF'
-- Load data
sales = LOAD '/sales.txt' USING PigStorage(',') 
    AS (date:chararray, amount:int, product:chararray);

-- Filter
high_value = FILTER sales BY amount > 100;

-- Group
by_product = GROUP high_value BY product;

-- Calculate statistics
stats = FOREACH by_product GENERATE 
    group as product,
    COUNT(high_value) as count,
    SUM(high_value.amount) as total,
    AVG(high_value.amount) as average;

-- Sort by total descending
sorted = ORDER stats BY total DESC;

-- Store results
STORE sorted INTO '/pig_stats' USING PigStorage(',');
EOF

# Run it
pig -f /tmp/advanced_pig.pig

# View results
hadoop fs -cat /pig_stats/*
```

---

## 🎯 Next Experiment

Ready for more? Try **Experiment 4: Sqoop Data Import** to transfer data between databases and Hadoop!

---

**Status**: ✅ Complete | **Difficulty**: Intermediate | **Time**: 15-20 minutes


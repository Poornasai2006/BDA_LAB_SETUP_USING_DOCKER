# Big Data Analytics Lab Experiments Guide

Complete guide for running all lab experiments using Docker containers.

**⭐ Reference**: For detailed Docker command syntax and container access instructions, see **CONTAINER_ACCESS.md**

---

## 🚀 Quick Start - All Commands Use Docker

### Universal Docker Access Pattern

All tools are accessed through containers. Use these patterns:

```bash
# For Hive (NEW - CORRECT WAY)
docker exec -it hive-server hive

# For Pig
docker exec -it namenode pig

# For MapReduce
docker exec namenode hadoop jar /path/to/job.jar jobclass /input /output

# For Sqoop
docker exec namenode sqoop [command]

# For MySQL
docker exec mysql-db mysql -u root -proot
```

---

## 📋 Experiment 1: MapReduce Word Count

### Objective
Write and execute a MapReduce program to count word occurrences in a text file.

### Steps

#### Step 1: Create Java Program
```bash
# Create wordcount.java
cat > /tmp/wordcount.java << 'EOF'
import java.io.IOException;
import java.util.StringTokenizer;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

public class wordcount {
    public static class myMapper extends Mapper<Object, Text, Text, IntWritable> {
        private final static IntWritable one = new IntWritable(1);
        private Text word = new Text();

        public void map(Object key, Text value, Context context) 
            throws IOException, InterruptedException {
            StringTokenizer itr = new StringTokenizer(value.toString());
            while (itr.hasMoreTokens()) {
                word.set(itr.nextToken());
                context.write(word, one);
            }
        }
    }

    public static class myReducer extends Reducer<Text, IntWritable, Text, IntWritable> {
        private IntWritable result = new IntWritable();

        public void reduce(Text key, Iterable<IntWritable> values, Context context)
            throws IOException, InterruptedException {
            int sum = 0;
            for (IntWritable val : values) {
                sum += val.get();
            }
            result.set(sum);
            context.write(key, result);
        }
    }

    public static void main(String[] args) throws Exception {
        Configuration conf = new Configuration();
        Job job = Job.getInstance(conf, "word count");
        job.setJarByClass(wordcount.class);
        job.setMapperClass(myMapper.class);
        job.setCombinerClass(myReducer.class);
        job.setReducerClass(myReducer.class);
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(IntWritable.class);
        FileInputFormat.addInputPath(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, new Path(args[1]));
        System.exit(job.waitForCompletion(true) ? 0 : 1);
    }
}
EOF
```

#### Step 2: Copy to Container and Compile
```bash
# Copy file to container
docker cp /tmp/wordcount.java namenode:/tmp/

# Compile in container
docker exec namenode javac /tmp/wordcount.java

# Create jar file
docker exec namenode jar cf /tmp/wordcount.jar -C /tmp wordcount*.class
```

#### Step 3: Create Input File
```bash
# Create sample input file
cat > /tmp/input.txt << 'EOF'
hadoop is great
hadoop is powerful
big data hadoop
hadoop mapreduce
hadoop hadoop
EOF

# Copy to container
docker cp /tmp/input.txt namenode:/tmp/input.txt

# Put file in HDFS
docker exec namenode hadoop fs -put /tmp/input.txt /input.txt
```

#### Step 4: Run MapReduce Job
```bash
# Execute the word count job
docker exec namenode hadoop jar /tmp/wordcount.jar wordcount /input.txt /output

# View results
docker exec namenode hadoop fs -cat /output/part-r-00000
```

#### Expected Output
```
big     1
data    1
great   1
hadoop  6
is      2
mapreduce   1
powerful    1
```

---

## 📋 Experiment 2: Hive SQL Queries

### Objective
Create Hive tables and execute SQL queries on distributed data.

### Steps

#### Step 1: Start Hive Shell
```bash
# ✅ CORRECT WAY (NEW)
docker exec -it hive-server hive
```

#### Step 2: Create Table
```sql
-- Create a sample table
CREATE TABLE employees (
    id INT,
    name STRING,
    department STRING,
    salary INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',';
```

#### Step 3: Load Data
```sql
-- Create sample data
INSERT INTO TABLE employees VALUES
(1, 'Alice', 'Engineering', 80000),
(2, 'Bob', 'Sales', 60000),
(3, 'Charlie', 'Engineering', 85000),
(4, 'Diana', 'HR', 55000),
(5, 'Eve', 'Sales', 65000);
```

#### Step 4: Run Queries
```sql
-- Simple SELECT
SELECT * FROM employees;

-- Filter and aggregate
SELECT department, COUNT(*) as count, AVG(salary) as avg_salary
FROM employees
GROUP BY department;

-- Find highest paid employees
SELECT name, salary FROM employees ORDER BY salary DESC LIMIT 3;

-- Join operation (create another table first)
CREATE TABLE departments (
    dept_name STRING,
    location STRING
);

INSERT INTO TABLE departments VALUES
('Engineering', 'Bangalore'),
('Sales', 'Mumbai'),
('HR', 'Delhi');
```

#### Step 5: Exit Hive
```sql
-- Type quit to exit
quit;
```

---

## 📋 Experiment 3: Pig Data Processing

### Objective
Use Pig to process and transform data using scripts.

### Steps

#### Step 1: Create Sample Data
```bash
# Create input data
cat > /tmp/sales.txt << 'EOF'
2024-01-01,100,Product A
2024-01-02,150,Product B
2024-01-03,200,Product A
2024-01-04,120,Product C
2024-01-05,180,Product B
EOF

# Copy to container
docker cp /tmp/sales.txt namenode:/tmp/

# Put in HDFS
docker exec namenode hadoop fs -put /tmp/sales.txt /sales.txt
```

#### Step 2: Create Pig Script
```bash
# Create pig script
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

# Copy to container
docker cp /tmp/sales_analysis.pig namenode:/tmp/
```

#### Step 3: Run Pig Script
```bash
# Interactive mode (start Pig shell)
docker exec -it namenode pig

# In Pig shell, run:
# run /tmp/sales_analysis.pig;
# quit;

# Or execute script directly
docker exec namenode pig -f /tmp/sales_analysis.pig

# View results
docker exec namenode hadoop fs -cat /pig_output/*
```

#### Expected Output
```
Product A,300
Product B,330
Product C,120
```

---

## 📋 Experiment 4: Sqoop Data Import

### Objective
Import data from MySQL to Hadoop using Sqoop.

### Steps

#### Step 1: Create MySQL Database and Table
```bash
# Access MySQL
docker exec -it mysql-db mysql -u root -proot

# In MySQL shell:
# CREATE DATABASE testdb;
# USE testdb;
# CREATE TABLE employees (
#     id INT PRIMARY KEY,
#     name VARCHAR(100),
#     department VARCHAR(50),
#     salary INT
# );
# INSERT INTO employees VALUES
# (1, 'Alice', 'Engineering', 80000),
# (2, 'Bob', 'Sales', 60000),
# (3, 'Charlie', 'Engineering', 85000);
# exit;
```

#### Step 2: Import Data with Sqoop
```bash
# Import from MySQL to HDFS
docker exec namenode sqoop import \
  --connect jdbc:mysql://mysql-db:3306/testdb \
  --username root \
  --password root \
  --table employees \
  -m 1 \
  --target-dir /sqoop_import/employees

# Verify import
docker exec namenode hadoop fs -cat /sqoop_import/employees/part-m-00000
```

#### Step 3: Export Data Back to MySQL
```bash
# First create output data in HDFS from Pig/Hive

# Export from HDFS to MySQL
docker exec namenode sqoop export \
  --connect jdbc:mysql://mysql-db:3306/testdb \
  --username root \
  --password root \
  --table employees \
  --export-dir /pig_output \
  -m 1
```

---

## 📋 Experiment 5: Hive with External Tables

### Objective
Create external Hive tables pointing to HDFS data.

### Steps

#### Step 1: Create Data File
```bash
# Create CSV file
cat > /tmp/products.csv << 'EOF'
1,Laptop,50000
2,Mouse,500
3,Keyboard,1000
4,Monitor,15000
5,Headphones,2000
EOF

# Put in HDFS
docker cp /tmp/products.csv namenode:/tmp/
docker exec namenode hadoop fs -put /tmp/products.csv /products.csv
```

#### Step 2: Create External Table
```bash
# Start Hive
docker exec -it hive-server hive
```

In Hive shell:
```sql
-- Create external table
CREATE EXTERNAL TABLE products (
    id INT,
    name STRING,
    price INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LOCATION '/products.csv';

-- Query the table
SELECT * FROM products;
SELECT name, price FROM products WHERE price > 1000;
SELECT COUNT(*) FROM products;

-- Calculate statistics
SELECT AVG(price) as avg_price, MAX(price) as max_price FROM products;
```

---

## 📋 Experiment 6: Join Operations

### Objective
Perform join operations between multiple tables.

### Steps

```bash
# Start Hive
docker exec -it hive-server hive
```

In Hive shell:
```sql
-- Create orders table
CREATE TABLE orders (
    order_id INT,
    product_id INT,
    quantity INT,
    total INT
);

-- Insert sample data
INSERT INTO TABLE orders VALUES
(1, 1, 2, 100000),
(2, 2, 5, 2500),
(3, 1, 1, 50000),
(4, 4, 1, 15000);

-- Inner join with products table
SELECT 
    o.order_id,
    p.name,
    o.quantity,
    o.total
FROM orders o
INNER JOIN products p ON o.product_id = p.id;

-- Left join
SELECT 
    p.id,
    p.name,
    COUNT(o.order_id) as order_count
FROM products p
LEFT JOIN orders o ON p.id = o.product_id
GROUP BY p.id, p.name;
```

---

## 📋 Experiment 7: Pig with Joins

### Objective
Join datasets using Pig.

### Steps

```bash
# Create order data
cat > /tmp/orders.txt << 'EOF'
1,101,2
2,102,5
3,101,1
4,104,1
EOF

docker cp /tmp/orders.txt namenode:/tmp/
docker exec namenode hadoop fs -put /tmp/orders.txt /orders.txt

# Create Pig script
cat > /tmp/join_analysis.pig << 'EOF'
-- Load tables
products = LOAD '/products.csv' USING PigStorage(',') 
    AS (id:int, name:chararray, price:int);
orders = LOAD '/orders.txt' USING PigStorage(',') 
    AS (order_id:int, product_id:int, quantity:int);

-- Join
joined = JOIN products BY id, orders BY product_id;

-- Select columns
result = FOREACH joined GENERATE 
    orders::order_id, 
    products::name, 
    orders::quantity, 
    (orders::quantity * products::price) as total;

-- Store
STORE result INTO '/join_results' USING PigStorage(',');
EOF

docker cp /tmp/join_analysis.pig namenode:/tmp/
docker exec namenode pig -f /tmp/join_analysis.pig
docker exec namenode hadoop fs -cat /join_results/*
```

---

## 📋 Experiment 8: Data Aggregation

### Objective
Perform aggregation operations on large datasets.

### Steps

```bash
# Start Hive
docker exec -it hive-server hive
```

In Hive shell:
```sql
-- Group by and aggregation
SELECT 
    department,
    COUNT(*) as employee_count,
    AVG(salary) as avg_salary,
    MIN(salary) as min_salary,
    MAX(salary) as max_salary,
    SUM(salary) as total_salary
FROM employees
GROUP BY department;

-- Having clause
SELECT 
    department,
    COUNT(*) as count
FROM employees
GROUP BY department
HAVING COUNT(*) > 1;

-- Distinct values
SELECT DISTINCT department FROM employees;

-- Multiple grouping
SELECT 
    department,
    COUNT(*) as count
FROM employees
GROUP BY department
ORDER BY count DESC;
```

---

## 📊 Data Files Directory Structure

```
workspace/
├── mapred/
│   ├── wordcount.java
│   ├── wordcount.class
│   ├── wordcount.jar
│   └── input.txt
├── pig_scripts/
│   ├── sales_analysis.pig
│   └── join_analysis.pig
└── outputs/
    ├── wordcount_output/
    ├── pig_output/
    └── join_results/
```

---

## 🔗 Common Docker Commands Reference

```bash
# Check data in HDFS
docker exec namenode hadoop fs -ls /
docker exec namenode hadoop fs -cat /file.txt

# Check job status
docker exec namenode hadoop job -list
docker exec namenode hadoop job -history

# View NameNode UI
# Open browser: http://localhost:50070

# View YARN ResourceManager
# Open browser: http://localhost:8088

# Check container logs
docker logs namenode
docker logs hive-server
docker logs mysql-db

# Clean up outputs
docker exec namenode hadoop fs -rm -r /output
docker exec namenode hadoop fs -rm -r /pig_output
```

---

## ✅ Verification Checklist

After each experiment:

- [ ] Data loaded successfully
- [ ] Job completed without errors
- [ ] Output files created in expected location
- [ ] Results verified with correct format
- [ ] Logs checked for warnings

---

## 🐛 Troubleshooting

### Hive Connection Issues
```bash
# Verify HiveServer2 is running
docker exec hive-server ps aux | grep hive

# Check HiveServer2 logs
docker logs hive-server

# Restart if needed
docker restart hive-server
```

### MapReduce Job Fails
```bash
# Check detailed logs
docker exec namenode hadoop logs

# Verify input file exists
docker exec namenode hadoop fs -ls /input.txt

# Check HDFS health
docker exec namenode hadoop dfsadmin -report
```

### MySQL Connection Issues
```bash
# Test MySQL connection
docker exec mysql-db mysql -u root -proot -e "SELECT 1;"

# Check if database exists
docker exec mysql-db mysql -u root -proot -e "SHOW DATABASES;"
```

---

## 📚 References

- [Hadoop Documentation](https://hadoop.apache.org/)
- [Hive Language Manual](https://cwiki.apache.org/confluence/display/Hive)
- [Pig Latin Reference](https://pig.apache.org/docs/r0.17.0/basic.html)
- [Sqoop User Guide](https://sqoop.apache.org/docs/1.4.7/SqoopUserGuide.html)

---

**All experiments use Docker containers - no local installation needed!** 🚀

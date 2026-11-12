# 🔗 Experiment 4: Sqoop Data Import/Export

## 🛠️ **Tool: Apache Sqoop**

**What is Sqoop?**
- Bridge between relational databases and Hadoop
- Transfers data between MySQL/PostgreSQL and HDFS
- **Use Case**: Import production data for analysis, or export results back to databases
- **Key Concepts**: JDBC connections, import, export, parallel processing

---

## 🎯 Objective
Import data from MySQL to Hadoop using Sqoop, and export results back.

---

## 📋 Steps

### Step 1: Create MySQL Database and Table

```bash
# Access MySQL shell
docker exec -it mysql-db mysql -u root -proot
```

Inside MySQL shell, run these commands:

```sql
CREATE DATABASE testdb;
USE testdb;

CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    department VARCHAR(50),
    salary INT
);

INSERT INTO employees VALUES
(1, 'Alice', 'Engineering', 80000),
(2, 'Bob', 'Sales', 60000),
(3, 'Charlie', 'Engineering', 85000),
(4, 'Diana', 'HR', 55000),
(5, 'Eve', 'Sales', 65000);

-- Verify data
SELECT * FROM employees;

-- Exit MySQL
exit;
```

**Expected Output:**
```
+----+---------+-------------+--------+
| id | name    | department  | salary |
+----+---------+-------------+--------+
|  1 | Alice   | Engineering | 80000  |
|  2 | Bob     | Sales       | 60000  |
|  3 | Charlie | Engineering | 85000  |
|  4 | Diana   | HR          | 55000  |
|  5 | Eve     | Sales       | 65000  |
+----+---------+-------------+--------+
```

---

### Step 2: Access NameNode Terminal

```bash
docker exec -it namenode bash
```

---

### Step 3: Import Data with Sqoop

```bash
# Import from MySQL to HDFS
sqoop import \
  --connect jdbc:mysql://mysql-db:3306/testdb \
  --username root \
  --password root \
  --table employees \
  -m 1 \
  --target-dir /sqoop_import/employees
```

**Expected Output:**
```
23/12/14 10:30:45 INFO sqoop.Sqoop: Running Sqoop version 1.4.7
...
23/12/14 10:30:50 INFO mapreduce.Job: Task Id: attempt_...
23/12/14 10:30:55 INFO mapreduce.Job: Task completed successfully
```

---

### Step 4: Verify Imported Data

```bash
# Check if import directory was created
hadoop fs -ls /sqoop_import/employees

# View the imported data
hadoop fs -cat /sqoop_import/employees/part-m-00000
```

**Expected Output:**
```
1,Alice,Engineering,80000
2,Bob,Sales,60000
3,Charlie,Engineering,85000
4,Diana,HR,55000
5,Eve,Sales,65000
```

---

### Step 5: Process Data with Pig (Optional)

```bash
# Create Pig script to process imported data
cat > /tmp/process_employees.pig << 'EOF'
-- Load imported data
employees = LOAD '/sqoop_import/employees/part-m-00000' 
    USING PigStorage(',') 
    AS (id:int, name:chararray, department:chararray, salary:int);

-- Filter high salary
high_earners = FILTER employees BY salary > 60000;

-- Group by department
by_dept = GROUP high_earners BY department;

-- Calculate totals
dept_stats = FOREACH by_dept GENERATE 
    group as department,
    COUNT(high_earners) as count,
    SUM(high_earners.salary) as total_salary;

-- Store results
STORE dept_stats INTO '/processed_employees' USING PigStorage(',');
EOF

# Run Pig script
pig -f /tmp/process_employees.pig

# View processed results
hadoop fs -cat /processed_employees/*
```

**Expected Output:**
```
Engineering,2,165000
Sales,1,65000
```

---

### Step 6: Export Results Back to MySQL

```bash
# First create output table in MySQL
docker exec -it mysql-db mysql -u root -proot -e "
USE testdb;
CREATE TABLE high_earners (
    department VARCHAR(50),
    count INT,
    total_salary INT
);"

# Export from HDFS to MySQL
sqoop export \
  --connect jdbc:mysql://mysql-db:3306/testdb \
  --username root \
  --password root \
  --table high_earners \
  --export-dir /processed_employees \
  -m 1
```

**Expected Output:**
```
23/12/14 10:35:20 INFO sqoop.Sqoop: Running Sqoop version 1.4.7
...
23/12/14 10:35:25 INFO mapreduce.Job: Task completed successfully
```

---

### Step 7: Verify Export

```bash
# Check exported data in MySQL
docker exec -it mysql-db mysql -u root -proot -e "
USE testdb;
SELECT * FROM high_earners;"
```

**Expected Output:**
```
+--------------+-------+--------------+
| department   | count | total_salary |
+--------------+-------+--------------+
| Engineering  |     2 |       165000 |
| Sales        |     1 |        65000 |
+--------------+-------+--------------+
```

---

## 📊 Sqoop Commands Reference

### Import Syntax
```bash
sqoop import \
  --connect jdbc:mysql://HOST:PORT/DATABASE \
  --username USERNAME \
  --password PASSWORD \
  --table TABLE_NAME \
  -m 1 \
  --target-dir /hdfs/path
```

### Export Syntax
```bash
sqoop export \
  --connect jdbc:mysql://HOST:PORT/DATABASE \
  --username USERNAME \
  --password PASSWORD \
  --table TABLE_NAME \
  --export-dir /hdfs/path \
  -m 1
```

### Key Parameters

| Parameter | Purpose |
|-----------|---------|
| `--connect` | JDBC connection string |
| `--username` | Database user |
| `--password` | Database password |
| `--table` | Table name to import/export |
| `--target-dir` | HDFS directory (import) |
| `--export-dir` | HDFS directory (export) |
| `-m 1` | Number of mappers (1 = single thread) |

---

## 🔄 Data Flow

```
MySQL Database
    ↓
Sqoop Import (JDBC)
    ↓
HDFS Files
    ↓
Pig/Hive Processing
    ↓
Processed Data (HDFS)
    ↓
Sqoop Export (JDBC)
    ↓
MySQL Database
```

---

## 💡 Learning Points

- ✅ Database connectivity with Sqoop
- ✅ Importing relational data to Hadoop
- ✅ Processing imported data with Pig/Hive
- ✅ Exporting results back to databases
- ✅ End-to-end data pipeline

---

## 🐛 Troubleshooting

**Connection refused?**
```bash
# Verify MySQL is running
docker ps | grep mysql

# Test MySQL connection
docker exec mysql-db mysql -u root -proot -e "SELECT 1;"

# Check JDBC driver
jar tf $(find / -name sqoop-1.4.7.jar 2>/dev/null) | grep mysql
```

**Import fails with "table not found"?**
```bash
# Verify table in MySQL
docker exec mysql-db mysql -u root -proot testdb -e "SHOW TABLES;"

# Check database exists
docker exec mysql-db mysql -u root -proot -e "SHOW DATABASES;"
```

**Permission denied on export?**
```bash
# Grant privileges in MySQL
docker exec mysql-db mysql -u root -proot -e "
GRANT ALL PRIVILEGES ON testdb.* TO 'root'@'%';
FLUSH PRIVILEGES;"
```

**HDFS directory exists error?**
```bash
# Remove existing directory
hadoop fs -rm -r /sqoop_import/employees

# Retry import
sqoop import ...
```

---

## 🎯 Advanced Example: Incremental Import

For large datasets, use incremental imports (only new/changed rows):

```bash
sqoop import \
  --connect jdbc:mysql://mysql-db:3306/testdb \
  --username root \
  --password root \
  --table employees \
  --target-dir /sqoop_incremental \
  --incremental append \
  --check-column id \
  --last-value 5 \
  -m 1
```

---

## 🎯 Next Experiment

Ready for more? Try **Experiment 5: Hive External Tables** to query HDFS data directly!

---

**Status**: ✅ Complete | **Difficulty**: Intermediate | **Time**: 15-20 minutes


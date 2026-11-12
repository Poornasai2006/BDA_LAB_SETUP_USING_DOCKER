# 🗄️ Experiment 2: Hive SQL Queries

## 🛠️ **Tool: Apache Hive**

**What is Hive?**
- SQL interface for Hadoop
- Converts SQL queries to MapReduce jobs automatically
- **Use Case**: Query large datasets using familiar SQL syntax without writing Java code
- **Key Concepts**: Tables, SQL queries, HiveQL, Metastore

---

## 🎯 Objective
Create Hive tables and execute SQL queries on distributed data.

---

## 📋 Steps

### Step 1: Start Hive Shell

```bash
docker exec -it hive-server hive
```

You'll see the Hive prompt:
```
hive>
```

### Step 2: Create Table

```sql
CREATE TABLE employees (
    id INT,
    name STRING,
    department STRING,
    salary INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',';
```

### Step 3: Load Sample Data

```sql
INSERT INTO TABLE employees VALUES
(1, 'Alice', 'Engineering', 80000),
(2, 'Bob', 'Sales', 60000),
(3, 'Charlie', 'Engineering', 85000),
(4, 'Diana', 'HR', 55000),
(5, 'Eve', 'Sales', 65000);
```

### Step 4: Run SQL Queries

**Simple SELECT:**
```sql
SELECT * FROM employees;
```

**Expected Output:**
```
1	Alice	Engineering	80000
2	Bob	Sales	60000
3	Charlie	Engineering	85000
4	Diana	HR	55000
5	Eve	Sales	65000
```

---

### Query 1: Filter Data

```sql
SELECT name, salary FROM employees WHERE salary > 60000;
```

**Output:**
```
Alice	80000
Charlie	85000
Eve	65000
```

---

### Query 2: Group and Aggregate

```sql
SELECT department, COUNT(*) as count, AVG(salary) as avg_salary
FROM employees
GROUP BY department;
```

**Output:**
```
Engineering	2	82500
HR	1	55000
Sales	2	62500
```

---

### Query 3: Order Results

```sql
SELECT name, salary FROM employees ORDER BY salary DESC LIMIT 3;
```

**Output:**
```
Charlie	85000
Alice	80000
Eve	65000
```

---

### Query 4: Aggregate Functions

```sql
SELECT 
    COUNT(*) as total_employees,
    AVG(salary) as avg_salary,
    MIN(salary) as min_salary,
    MAX(salary) as max_salary,
    SUM(salary) as total_salary
FROM employees;
```

**Output:**
```
5	73000	55000	85000	365000
```

---

### Step 5: Create Another Table for Joins

```sql
CREATE TABLE departments (
    dept_name STRING,
    location STRING
);

INSERT INTO TABLE departments VALUES
('Engineering', 'Bangalore'),
('Sales', 'Mumbai'),
('HR', 'Delhi');
```

---

### Query 5: Join Tables

```sql
SELECT 
    e.name,
    e.department,
    d.location,
    e.salary
FROM employees e
LEFT JOIN departments d ON e.department = d.dept_name;
```

**Output:**
```
Alice	Engineering	Bangalore	80000
Bob	Sales	Mumbai	60000
Charlie	Engineering	Bangalore	85000
Diana	HR	Delhi	55000
Eve	Sales	Mumbai	65000
```

---

### Step 6: Exit Hive

```sql
quit;
```

---

## ✅ SQL Commands Summary

| Command | Purpose |
|---------|---------|
| `CREATE TABLE` | Create new table |
| `INSERT INTO` | Insert data into table |
| `SELECT` | Query data |
| `WHERE` | Filter rows |
| `GROUP BY` | Group results |
| `ORDER BY` | Sort results |
| `JOIN` | Combine tables |
| `COUNT()`, `AVG()`, `SUM()` | Aggregate functions |
| `LIMIT` | Limit result rows |

---

## 🔍 How It Works

1. You write SQL query in Hive
2. Hive converts SQL → MapReduce job
3. MapReduce job executes on Hadoop cluster
4. Results returned to Hive shell
5. You see results like a database query

```
SQL Query
  ↓
HiveQL Parser
  ↓
MapReduce Job
  ↓
Execute on Hadoop
  ↓
Return Results
```

---

## 💡 Learning Points

- ✅ SQL syntax and HiveQL
- ✅ Table creation and data loading
- ✅ Filtering, sorting, and aggregation
- ✅ GROUP BY operations
- ✅ JOIN operations
- ✅ How SQL converts to MapReduce

---

## 🐛 Troubleshooting

**Hive connection refused?**
```bash
# Check if HiveServer2 is running
docker ps | grep hive

# View logs
docker logs hive-server

# Restart HiveServer2
docker-compose restart hive-server
```

**Table not found error?**
```bash
# List all tables
SHOW TABLES;

# Check table schema
DESCRIBE employees;
```

**Query takes too long?**
```bash
# Check job status (in another terminal)
docker exec namenode hadoop job -list

# View MapReduce UI
# Open http://localhost:8088 in browser
```

---

## 🎯 Next Experiment

Ready for more? Try **Experiment 3: Pig Data Processing** to transform data using Pig scripts!

---

**Status**: ✅ Complete | **Difficulty**: Beginner | **Time**: 10-15 minutes


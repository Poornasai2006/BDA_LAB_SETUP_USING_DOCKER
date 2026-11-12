# 🐷 Experiment 7: Pig Joins

## 🛠️ **Tool: Apache Pig (JOIN operations)**

**Pig JOINs Overview:**
- Combine datasets based on common columns
- Similar to SQL joins but using Pig Latin syntax
- **Use Case**: Complex data transformations and correlations
- **Key Concepts**: JOIN, GROUP, FOREACH with complex transformations

---

## 🎯 Objective
Join datasets using Pig and perform complex transformations.

---

## 📋 Steps

### Step 1: Create Sample Data Files

```bash
docker exec -it namenode bash
```

Create employees data:
```bash
cat > /tmp/employees.txt << 'EOF'
1,Alice,1,80000
2,Bob,2,60000
3,Charlie,1,85000
4,Diana,3,55000
5,Eve,2,65000
EOF
```

Create departments data:
```bash
cat > /tmp/departments.txt << 'EOF'
1,Engineering,Bangalore
2,Sales,Mumbai
3,HR,Delhi
4,Finance,Chennai
EOF
```

---

### Step 2: Upload to HDFS

```bash
# Create directories
hadoop fs -mkdir -p /data/employees
hadoop fs -mkdir -p /data/departments

# Upload files
hadoop fs -put /tmp/employees.txt /data/employees/
hadoop fs -put /tmp/departments.txt /data/departments/

# Verify
hadoop fs -ls /data/employees/
hadoop fs -ls /data/departments/
```

---

### Step 3: Create Pig Script with JOIN

```bash
cat > /tmp/employee_dept_join.pig << 'EOF'
-- Load employee data
employees = LOAD '/data/employees/employees.txt' 
    USING PigStorage(',') 
    AS (emp_id:int, name:chararray, dept_id:int, salary:int);

-- Load department data
departments = LOAD '/data/departments/departments.txt' 
    USING PigStorage(',') 
    AS (dept_id:int, dept_name:chararray, location:chararray);

-- Join employees with departments
employee_dept = JOIN employees BY dept_id, departments BY dept_id;

-- Select and rename columns
result = FOREACH employee_dept GENERATE 
    employees::emp_id as emp_id,
    employees::name as name,
    employees::salary as salary,
    departments::dept_name as dept_name,
    departments::location as location;

-- Store results
STORE result INTO '/pig_join_output' USING PigStorage(',');
EOF
```

---

### Step 4: Run Pig Script

```bash
# Execute the script
pig -f /tmp/employee_dept_join.pig
```

**Expected Output:**
```
[Successfully stored result in directory /pig_join_output]
```

---

### Step 5: View Results

```bash
# Check output directory
hadoop fs -ls /pig_join_output

# View results
hadoop fs -cat /pig_join_output/part*
```

**Expected Output:**
```
1,Alice,80000,Engineering,Bangalore
2,Bob,60000,Sales,Mumbai
3,Charlie,85000,Engineering,Bangalore
4,Diana,55000,HR,Delhi
5,Eve,65000,Sales,Mumbai
```

---

## 🔍 More Complex JOIN Examples

### Example 2: Filter After JOIN

Create script with filtering:

```bash
cat > /tmp/high_salary_join.pig << 'EOF'
-- Load data
employees = LOAD '/data/employees/employees.txt' 
    USING PigStorage(',') 
    AS (emp_id:int, name:chararray, dept_id:int, salary:int);

departments = LOAD '/data/departments/departments.txt' 
    USING PigStorage(',') 
    AS (dept_id:int, dept_name:chararray, location:chararray);

-- Join
employee_dept = JOIN employees BY dept_id, departments BY dept_id;

-- Filter: salary > 60000
high_salary = FILTER employee_dept BY employees::salary > 60000;

-- Select columns
result = FOREACH high_salary GENERATE 
    employees::name as name,
    employees::salary as salary,
    departments::dept_name as dept_name;

-- Store results
STORE result INTO '/pig_high_salary' USING PigStorage(',');
EOF

# Run it
pig -f /tmp/high_salary_join.pig

# View results
hadoop fs -cat /pig_high_salary/part*
```

**Expected Output:**
```
Alice,80000,Engineering
Charlie,85000,Engineering
Eve,65000,Sales
```

---

### Example 3: Aggregation After JOIN

Group and aggregate joined data:

```bash
cat > /tmp/dept_stats_join.pig << 'EOF'
-- Load data
employees = LOAD '/data/employees/employees.txt' 
    USING PigStorage(',') 
    AS (emp_id:int, name:chararray, dept_id:int, salary:int);

departments = LOAD '/data/departments/departments.txt' 
    USING PigStorage(',') 
    AS (dept_id:int, dept_name:chararray, location:chararray);

-- Join
employee_dept = JOIN employees BY dept_id, departments BY dept_id;

-- Group by department
by_dept = GROUP employee_dept BY departments::dept_name;

-- Calculate statistics
dept_stats = FOREACH by_dept GENERATE 
    group as dept_name,
    COUNT(employee_dept) as emp_count,
    SUM(employee_dept.employees::salary) as total_salary,
    AVG(employee_dept.employees::salary) as avg_salary;

-- Store results
STORE dept_stats INTO '/pig_dept_stats' USING PigStorage(',');
EOF

# Run it
pig -f /tmp/dept_stats_join.pig

# View results
hadoop fs -cat /pig_dept_stats/part*
```

**Expected Output:**
```
Engineering,2,165000,82500.0
Sales,2,125000,62500.0
HR,1,55000,55000.0
```

---

### Example 4: Three-Way JOIN

Create orders data:

```bash
cat > /tmp/orders.txt << 'EOF'
1001,1,5000
1002,2,8000
1003,3,3000
1004,5,7000
EOF

# Upload to HDFS
hadoop fs -put /tmp/orders.txt /data/orders/

# Create Pig script
cat > /tmp/three_way_join.pig << 'EOF'
-- Load all data
employees = LOAD '/data/employees/employees.txt' 
    USING PigStorage(',') 
    AS (emp_id:int, name:chararray, dept_id:int, salary:int);

departments = LOAD '/data/departments/departments.txt' 
    USING PigStorage(',') 
    AS (dept_id:int, dept_name:chararray, location:chararray);

orders = LOAD '/data/orders/orders.txt' 
    USING PigStorage(',') 
    AS (order_id:int, emp_id:int, amount:int);

-- First JOIN: employees with orders
emp_orders = JOIN employees BY emp_id, orders BY emp_id;

-- Second JOIN: with departments
full_join = JOIN emp_orders BY (employees::dept_id), 
                    departments BY dept_id;

-- Select columns
result = FOREACH full_join GENERATE 
    orders::order_id as order_id,
    employees::name as employee,
    orders::amount as amount,
    departments::dept_name as dept;

-- Store results
STORE result INTO '/pig_three_way_join' USING PigStorage(',');
EOF

# Run it
pig -f /tmp/three_way_join.pig

# View results
hadoop fs -cat /pig_three_way_join/part*
```

**Expected Output:**
```
1001,Alice,5000,Engineering
1002,Bob,8000,Sales
1003,Charlie,3000,Engineering
1004,Eve,7000,Sales
```

---

## 📊 JOIN Types in Pig

```
INNER JOIN:
    JOIN table1 BY key, table2 BY key
    → Only matching records

LEFT OUTER JOIN:
    JOIN table1 BY key LEFT OUTER, table2 BY key
    → All from left table + matching right

FULL OUTER JOIN:
    JOIN table1 BY key FULL OUTER, table2 BY key
    → All from both tables

RIGHT OUTER JOIN:
    JOIN table1 BY key RIGHT OUTER, table2 BY key
    → Matching left + all from right
```

---

## 💡 Pig JOIN Syntax

```pig
-- Basic JOIN
result = JOIN table1 BY column1, table2 BY column2;

-- Multiple keys
result = JOIN table1 BY (key1, key2), 
              table2 BY (key1, key2);

-- With aliases
result = FOREACH result GENERATE 
    table1::column1 as col1,
    table2::column2 as col2;

-- Chaining JOINs
join1 = JOIN table1 BY key, table2 BY key;
join2 = JOIN join1 BY key, table3 BY key;
```

---

## 🔍 Data Flow

```
employees.txt          departments.txt
      ↓                       ↓
   LOAD              +       LOAD
      ↓              |        ↓
   tuple1 ---- JOIN ----- tuple2
                 ↓
           Joined tuples
                 ↓
            FILTER/GROUP
                 ↓
         Transformed tuples
                 ↓
              STORE
                 ↓
          /pig_join_output
```

---

## 💡 Learning Points

- ✅ Pig JOIN syntax and operations
- ✅ Multiple key joins
- ✅ Filtering joined data
- ✅ Aggregating joined results
- ✅ Three-way joins
- ✅ Complex data transformations

---

## 🐛 Troubleshooting

**JOIN produces no results?**
```bash
# Verify input files
hadoop fs -cat /data/employees/employees.txt
hadoop fs -cat /data/departments/departments.txt

# Check join keys exist in both files
# Make sure dept_id column exists in both
```

**Column not found error?**
```pig
-- Use full table reference in FOREACH
FOREACH joined GENERATE 
    employees::name,        -- correct
    -- name,                -- wrong
    departments::dept_name;
```

**Script syntax error?**
```bash
# Validate Pig script without running
pig -check -f /tmp/script.pig

# Run in debug mode
pig -debug -f /tmp/script.pig
```

---

## 🎯 Exit NameNode Terminal

```bash
exit
```

---

## 🎯 Next Experiment

Ready for more? Try **Experiment 8: Data Aggregation** for advanced statistical operations!

---

**Status**: ✅ Complete | **Difficulty**: Intermediate | **Time**: 20-25 minutes


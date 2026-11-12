# 🔗 Experiment 6: Join Operations

## 🛠️ **Tool: Apache Hive (JOIN operations)**

**What are JOINs?**
- Combine data from multiple tables based on common columns
- Similar to SQL database joins
- **Use Case**: Correlate data from different sources (employees + departments, orders + products)
- **Key Concepts**: INNER JOIN, LEFT JOIN, RIGHT JOIN, FULL OUTER JOIN

---

## 🎯 Objective
Perform join operations between multiple Hive tables.

---

## 📋 Steps

### Step 1: Start Hive Shell

```bash
docker exec -it hive-server hive
```

---

### Step 2: Create Base Tables

Create employees table:
```sql
CREATE TABLE employees (
    emp_id INT,
    name STRING,
    dept_id INT,
    salary INT
);

INSERT INTO TABLE employees VALUES
(1, 'Alice', 1, 80000),
(2, 'Bob', 2, 60000),
(3, 'Charlie', 1, 85000),
(4, 'Diana', 3, 55000),
(5, 'Eve', 2, 65000);
```

Create departments table:
```sql
CREATE TABLE departments (
    dept_id INT,
    dept_name STRING,
    location STRING
);

INSERT INTO TABLE departments VALUES
(1, 'Engineering', 'Bangalore'),
(2, 'Sales', 'Mumbai'),
(3, 'HR', 'Delhi'),
(4, 'Finance', 'Chennai');
```

---

### Step 3: Verify Data

```sql
-- Check employees
SELECT * FROM employees;

-- Check departments
SELECT * FROM departments;
```

---

## 🔗 JOIN Examples

### Example 1: INNER JOIN

Find employees and their departments:

```sql
SELECT 
    e.emp_id,
    e.name,
    e.salary,
    d.dept_name,
    d.location
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id;
```

**Output:**
```
1	Alice	80000	Engineering	Bangalore
2	Bob	60000	Sales	Mumbai
3	Charlie	85000	Engineering	Bangalore
4	Diana	55000	HR	Delhi
5	Eve	65000	Sales	Mumbai
```

**Explanation**: Returns only matching records (employees with departments).

---

### Example 2: LEFT JOIN (LEFT OUTER JOIN)

Get all employees, including those without departments:

```sql
SELECT 
    e.emp_id,
    e.name,
    e.dept_id,
    d.dept_name
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id;
```

**Output:**
```
1	Alice	1	Engineering
2	Bob	2	Sales
3	Charlie	1	Engineering
4	Diana	3	HR
5	Eve	2	Sales
```

**Explanation**: Returns all employees, with department info where it exists.

---

### Example 3: RIGHT JOIN (RIGHT OUTER JOIN)

Get all departments, even if no employees:

```sql
SELECT 
    d.dept_id,
    d.dept_name,
    e.emp_id,
    e.name
FROM employees e
RIGHT JOIN departments d ON e.dept_id = d.dept_id;
```

**Output:**
```
1	Engineering	1	Alice
1	Engineering	3	Charlie
2	Sales	2	Bob
2	Sales	5	Eve
3	HR	4	Diana
4	Finance	NULL	NULL
```

**Explanation**: Returns all departments, even Finance (which has no employees).

---

### Example 4: FULL OUTER JOIN

Get all records from both tables:

```sql
SELECT 
    e.emp_id,
    e.name,
    d.dept_id,
    d.dept_name
FROM employees e
FULL OUTER JOIN departments d ON e.dept_id = d.dept_id;
```

---

### Example 5: Cross Join (Cartesian Product)

Combine every employee with every department:

```sql
SELECT 
    e.name,
    d.dept_name
FROM employees e
CROSS JOIN departments d
LIMIT 10;
```

**Output:**
```
Alice	Engineering
Alice	Sales
Alice	HR
Alice	Finance
Bob	Engineering
Bob	Sales
...
```

---

## 📊 JOIN Types Visualization

```
INNER JOIN:
    e.dept_id = d.dept_id
    ↓
    Only matching rows
    
LEFT JOIN:
    e.dept_id = d.dept_id
    ↓
    All from LEFT table + matching from RIGHT

RIGHT JOIN:
    e.dept_id = d.dept_id
    ↓
    Matching from LEFT + all from RIGHT table

FULL OUTER JOIN:
    e.dept_id = d.dept_id
    ↓
    All from both tables
```

---

## 🔍 Complex JOIN Examples

### Example 6: Multiple Conditions

```sql
SELECT 
    e.name,
    d.dept_name,
    e.salary
FROM employees e
INNER JOIN departments d 
    ON e.dept_id = d.dept_id 
    AND e.salary > 60000;
```

**Output:**
```
Alice	Engineering	80000
Charlie	Engineering	85000
Eve	Sales	65000
```

---

### Example 7: Self Join

Compare employees with each other:

```sql
SELECT 
    e1.name as employee1,
    e2.name as employee2,
    e1.salary as salary1,
    e2.salary as salary2
FROM employees e1
JOIN employees e2 
    ON e1.dept_id = e2.dept_id 
    AND e1.emp_id < e2.emp_id;
```

**Output:**
```
Alice	Charlie	80000	85000
Bob	Eve	60000	65000
```

---

### Example 8: Three-Way Join

Add salary levels table:

```sql
CREATE TABLE salary_levels (
    level_id INT,
    level_name STRING,
    min_salary INT,
    max_salary INT
);

INSERT INTO TABLE salary_levels VALUES
(1, 'Junior', 40000, 60000),
(2, 'Senior', 60000, 80000),
(3, 'Lead', 80000, 120000);

-- Three-way join
SELECT 
    e.name,
    d.dept_name,
    sl.level_name,
    e.salary
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
JOIN salary_levels sl 
    ON e.salary BETWEEN sl.min_salary AND sl.max_salary;
```

**Output:**
```
Alice	Engineering	Lead	80000
Bob	Sales	Senior	60000
Charlie	Engineering	Lead	85000
Diana	HR	Junior	55000
Eve	Sales	Senior	65000
```

---

### Example 9: Aggregation After JOIN

Find department salary statistics:

```sql
SELECT 
    d.dept_name,
    COUNT(e.emp_id) as employee_count,
    AVG(e.salary) as avg_salary,
    MIN(e.salary) as min_salary,
    MAX(e.salary) as max_salary
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_name
ORDER BY avg_salary DESC;
```

**Output:**
```
Engineering	2	82500	80000	85000
Sales	2	62500	60000	65000
HR	1	55000	55000	55000
Finance	0	NULL	NULL	NULL
```

---

## 💡 JOIN Best Practices

1. **Use aliases** for clarity: `e` for employees, `d` for departments
2. **Specify JOIN type** explicitly (INNER, LEFT, etc.)
3. **Filter early**: Apply WHERE before JOIN when possible
4. **Use indexes** on JOIN columns for performance
5. **Limit joined columns**: SELECT only needed columns

---

## 🐛 Troubleshooting

**No results from JOIN?**
```sql
-- Check if join condition is correct
SELECT * FROM employees LIMIT 5;
SELECT * FROM departments LIMIT 5;

-- Verify column names and types
DESCRIBE employees;
DESCRIBE departments;
```

**JOIN takes too long?**
```sql
-- Check if MapReduce is running (another terminal)
docker exec namenode hadoop job -list

-- View YARN UI
-- Open http://localhost:8088 in browser
```

**Ambiguous column error?**
```sql
-- Always use table alias when column exists in both tables
SELECT e.emp_id, e.name, d.dept_name
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id;
```

---

## 🎯 Exit Hive

When done, type:
```sql
quit;
```

---

## 🎯 Next Experiment

Ready for more? Try **Experiment 7: Pig Joins** to perform similar operations using Pig!

---

**Status**: ✅ Complete | **Difficulty**: Intermediate | **Time**: 20-25 minutes


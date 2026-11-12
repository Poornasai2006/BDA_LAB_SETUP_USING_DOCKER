# 🧪 Big Data Lab Experiments Index

Complete guide to all 8 experiments for learning Hadoop, Hive, Pig, and Sqoop.

---

## 📋 Experiments Overview

| # | Experiment | Tool | Difficulty | Time | Key Concepts |
|---|-----------|------|-----------|------|--------------|
| **0** | [HDFS Commands](#0-hdfs-commands) | Hadoop HDFS | Beginner | 10-15 min | HDFS basics, file operations |
| 1 | [MapReduce WordCount](#1-mapreduce-wordcount) | Hadoop MapReduce | Beginner | 10-15 min | Distributed computing, Map-Reduce pattern |
| 2 | [Hive SQL Queries](#2-hive-sql-queries) | Apache Hive | Beginner | 10-15 min | SQL queries, table creation, aggregation |
| 3 | [Pig Data Processing](#3-pig-data-processing) | Apache Pig | Intermediate | 15-20 min | ETL, data transformation, Pig Latin |
| 4 | [Sqoop Import/Export](#4-sqoop-import-export) | Apache Sqoop | Intermediate | 15-20 min | Database connectivity, data transfer |
| 5 | [Hive External Tables](#5-hive-external-tables) | Apache Hive | Intermediate | 15-20 min | External tables, HDFS queries |
| 6 | [Join Operations](#6-join-operations) | Apache Hive | Intermediate | 20-25 min | INNER/LEFT/RIGHT/FULL JOINs, multi-table queries |
| 7 | [Pig Joins](#7-pig-joins) | Apache Pig | Intermediate | 20-25 min | Complex joins, data correlation |
| 8 | [Data Aggregation](#8-data-aggregation) | Apache Hive | Intermediate | 15-20 min | GROUP BY, aggregate functions, statistics |

**Total Time**: ~3.5-4.5 hours | **Total Difficulty**: Beginner → Intermediate

---

## 🎯 Quick Start by Learning Path

### 👶 Beginner Path (Start Here!)
0. **Experiment 0**: HDFS Commands - **START HERE! Foundation for all experiments**
1. **Experiment 1**: MapReduce WordCount - Understand distributed computing basics
2. **Experiment 2**: Hive SQL Queries - Learn SQL on Hadoop

### 📚 Intermediate Path (After Beginner)
3. **Experiment 3**: Pig Data Processing - Learn ETL transformations
4. **Experiment 5**: Hive External Tables - Work with HDFS data
5. **Experiment 6**: Join Operations - Combine multiple datasets

### 🚀 Advanced Path (Build on Intermediate)
6. **Experiment 4**: Sqoop Import/Export - Transfer production data
7. **Experiment 7**: Pig Joins - Complex correlations
8. **Experiment 8**: Data Aggregation - Extract insights from data

---

## 📖 Detailed Experiment Descriptions

### 0. HDFS Commands

**🛠️ Tool**: Hadoop HDFS  
**📚 What You'll Learn**:
- HDFS file system basics
- Listing, uploading, downloading files
- Creating directories and managing files
- HDFS permissions and health checks

**🎯 Objective**: Master essential HDFS commands (Foundation for all experiments!)

**📂 File**: `0_HDFS_Commands.md`

**Key Commands**:
```bash
hadoop fs -ls /                    # List files
hadoop fs -put file.txt /          # Upload file
hadoop fs -get /file.txt file.txt  # Download file
hadoop fs -cat /file.txt           # View content
hadoop fs -mkdir /directory        # Create directory
hadoop fs -rm /file.txt            # Delete file
```

**⚠️ WHY THIS IS FIRST**:
- All other experiments depend on HDFS operations
- Learn to upload/download/manage files FIRST
- No point doing MapReduce without knowing HDFS
- Fastest way to get productive with Hadoop

---

### 1. MapReduce WordCount

**🛠️ Tool**: Hadoop MapReduce  
**📚 What You'll Learn**: 
- How distributed computing works
- Map → Shuffle → Reduce pattern
- Compiling and running Java MapReduce jobs
- HDFS file operations

**🎯 Objective**: Count word occurrences in a text file using MapReduce

**📂 File**: `1_MapReduce_WordCount.md`

**Key Commands**:
```bash
docker exec -it namenode bash
javac -d . wordcount.java
jar -cvf wordcount.jar *.class
hadoop jar wordcount.jar wordcount /input.txt /output
```

---

### 2. Hive SQL Queries

**🛠️ Tool**: Apache Hive  
**📚 What You'll Learn**:
- Writing SQL queries on Hadoop
- Creating Hive tables
- SELECT, WHERE, GROUP BY operations
- JOIN operations basics

**🎯 Objective**: Query data using familiar SQL syntax

**📂 File**: `2_Hive_SQL_Queries.md`

**Key Commands**:
```bash
docker exec -it hive-server hive
CREATE TABLE employees (id INT, name STRING, salary INT);
SELECT * FROM employees WHERE salary > 60000;
```

---

### 3. Pig Data Processing

**🛠️ Tool**: Apache Pig  
**📚 What You'll Learn**:
- Pig Latin scripting language
- Data filtering and transformation
- GROUP BY and aggregation
- Loading and storing data

**🎯 Objective**: Transform data using Pig scripts

**📂 File**: `3_Pig_Data_Processing.md`

**Key Commands**:
```bash
docker exec -it namenode bash
pig -f /tmp/script.pig
hadoop fs -cat /pig_output/*
```

---

### 4. Sqoop Import/Export

**🛠️ Tool**: Apache Sqoop  
**📚 What You'll Learn**:
- Transferring data from MySQL to Hadoop
- Importing production databases
- Exporting results back to databases
- JDBC connectivity

**🎯 Objective**: Bridge relational databases and Hadoop

**📂 File**: `4_Sqoop_Import.md`

**Key Commands**:
```bash
sqoop import \
  --connect jdbc:mysql://mysql-db:3306/testdb \
  --table employees \
  --target-dir /sqoop_import/employees

sqoop export \
  --connect jdbc:mysql://mysql-db:3306/testdb \
  --table results \
  --export-dir /processed_data
```

---

### 5. Hive External Tables

**🛠️ Tool**: Apache Hive (External Tables)  
**📚 What You'll Learn**:
- Creating external Hive tables
- Querying HDFS data directly
- Difference between managed and external tables
- Data sharing and discovery

**🎯 Objective**: Query HDFS files without copying them

**📂 File**: `5_Hive_External_Tables.md`

**Key Commands**:
```bash
docker exec -it hive-server hive
CREATE EXTERNAL TABLE products (
    id INT, name STRING, price INT
)
LOCATION '/data';

SELECT * FROM products WHERE price > 1000;
```

---

### 6. Join Operations

**🛠️ Tool**: Apache Hive (JOINs)  
**📚 What You'll Learn**:
- INNER JOIN operations
- LEFT/RIGHT/FULL OUTER JOINs
- Multiple table joins
- Join optimization

**🎯 Objective**: Combine data from multiple tables

**📂 File**: `6_Join_Operations.md`

**Key Commands**:
```bash
SELECT e.name, d.dept_name, e.salary
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
WHERE e.salary > 60000;
```

---

### 7. Pig Joins

**🛠️ Tool**: Apache Pig (JOINs)  
**📚 What You'll Learn**:
- Joining datasets in Pig
- Complex data correlations
- Multi-way joins
- FOREACH with complex transformations

**🎯 Objective**: Perform joins and transformations using Pig

**📂 File**: `7_Pig_Joins.md`

**Key Commands**:
```bash
employees = LOAD '/data/employees' ...
departments = LOAD '/data/departments' ...
result = JOIN employees BY dept_id, departments BY dept_id;
```

---

### 8. Data Aggregation

**🛠️ Tool**: Apache Hive (Aggregation)  
**📚 What You'll Learn**:
- GROUP BY operations
- Aggregate functions (COUNT, SUM, AVG, MIN, MAX)
- HAVING clause
- Statistical calculations

**🎯 Objective**: Extract insights through aggregation and statistics

**📂 File**: `8_Data_Aggregation.md`

**Key Commands**:
```bash
SELECT 
    category,
    COUNT(*) as count,
    SUM(amount) as total,
    AVG(amount) as average
FROM sales
GROUP BY category
HAVING SUM(amount) > 100000;
```

---

## 🔗 Prerequisites

### Required
- Docker running
- All 8 containers started: `docker-compose up -d`
- NameNode accessible: `docker exec -it namenode bash`

### Knowledge
- Basic Linux commands
- Basic SQL (for Hive experiments)
- Basic Java (for MapReduce experiment)

---

## 📚 How to Run Each Experiment

### Step 1: Pick an Experiment
Choose from the list above based on your learning path

### Step 2: Open the Experiment File
```bash
# Example: Read Experiment 1
cat 1_MapReduce_WordCount.md
```

### Step 3: Follow Step-by-Step Instructions
Each experiment has numbered steps with:
- Command to run
- Expected output
- Explanation

### Step 4: Troubleshooting
Each experiment includes troubleshooting section if something fails

### Step 5: Verify Results
Check output directory or query to confirm success

---

## 🎓 Learning Outcomes

After completing all 8 experiments, you'll understand:

✅ **Distributed Computing**
- MapReduce pattern and distributed job execution
- HDFS file operations

✅ **Big Data Tools**
- Hadoop, HDFS, YARN fundamentals
- Hive SQL interface
- Pig Latin scripts
- Sqoop data transfer

✅ **Data Processing**
- ETL transformations
- Filtering and aggregation
- Complex joins
- Statistical analysis

✅ **Real-World Skills**
- Importing production databases
- Processing big datasets
- Creating data pipelines
- Extracting business insights

---

## 📊 Data Size Guidelines

For **learning purposes**:
- Small datasets: 100-1000 rows (current lab)
- Medium datasets: 10,000-100,000 rows
- Large datasets: 1 million+ rows

All lab experiments use small datasets for quick results and learning.

---

## 🔧 Common Commands Across All Experiments

### Accessing Containers
```bash
docker exec -it namenode bash           # Hadoop terminal
docker exec -it hive-server hive        # Hive shell
docker exec -it namenode pig            # Pig shell
docker exec -it mysql-db mysql -u root -proot  # MySQL
```

### HDFS Operations
```bash
hadoop fs -ls /                         # List files
hadoop fs -put file.txt /               # Upload file
hadoop fs -cat /file.txt                # View file
hadoop fs -rm -r /directory             # Delete
```

### Job Monitoring
```bash
hadoop job -list                        # Running jobs
hadoop dfsadmin -report                 # HDFS status
docker logs namenode                    # Container logs
```

### Web UIs
```
NameNode:    http://localhost:50070
YARN:        http://localhost:8088
JobHistory:  http://localhost:8188
```

---

## 💡 Tips for Success

1. **Read the entire experiment** before starting
2. **Create output directories** before running jobs
3. **Check HDFS path** if job fails (use `hadoop fs -ls /`)
4. **View logs** if something goes wrong (use `docker logs`)
5. **Take notes** on what you learn
6. **Experiment** - modify data and scripts to explore more
7. **Do them in order** - each builds on previous knowledge

---

## 📞 For Additional Help

All guides are organized in the `guides/` folder:

- **guides/QUICK_START.md** - Get running in 3 commands
- **guides/SETUP_GUIDE.md** - Detailed setup & troubleshooting
- **guides/CONTAINER_ACCESS.md** - How to access containers
- **guides/FIRST_TIME_SETUP.md** - First-time user guide
- **guides/CLEANUP_GUIDE.md** - Cleanup procedures

---

## 🚀 Next Steps After All Experiments

1. **Combine tools**: Create multi-tool pipelines (Sqoop → Hive → Pig → Export)
2. **Real datasets**: Use larger, more complex data
3. **Production setup**: Deploy to real Hadoop cluster
4. **Advanced tools**: Learn Spark, HBase, Kafka
5. **Cloud platforms**: Try AWS EMR, Google Cloud Dataproc, Azure HDInsight

---

## 📞 Getting Help

### Within Lab:
- See `CONTAINER_ACCESS.md` for terminal commands
- See `SETUP_GUIDE.md` for troubleshooting
- Check troubleshooting sections in each experiment

### External Resources:
- [Hadoop Docs](https://hadoop.apache.org/)
- [Hive Manual](https://cwiki.apache.org/confluence/display/Hive)
- [Pig Guide](https://pig.apache.org/docs/r0.17.0/basic.html)
- [Sqoop Guide](https://sqoop.apache.org/docs/1.4.7/SqoopUserGuide.html)

---

## ✅ Experiment Completion Checklist

Use this to track your progress:

- [ ] 1. MapReduce WordCount - Completed
- [ ] 2. Hive SQL Queries - Completed
- [ ] 3. Pig Data Processing - Completed
- [ ] 4. Sqoop Import/Export - Completed
- [ ] 5. Hive External Tables - Completed
- [ ] 6. Join Operations - Completed
- [ ] 7. Pig Joins - Completed
- [ ] 8. Data Aggregation - Completed

**All 8 Experiments Completed!** 🎉

---

## 🎓 Educational Purpose

This lab is designed for:
- ✅ Learning big data concepts
- ✅ Hands-on experimentation
- ✅ Understanding distributed systems
- ✅ Building practical skills
- ✅ College coursework and projects

**Perfect for students and professionals learning big data!** 🚀

---

**Last Updated**: 2026 | **Version**: 1.0 | **Status**: ✅ Production Ready


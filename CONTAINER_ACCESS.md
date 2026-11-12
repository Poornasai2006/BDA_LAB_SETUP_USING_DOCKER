# 🖥️ Accessing Containers & Running Commands

This guide explains how to access the Hadoop/HDFS bash terminal and run commands inside Docker containers. **This is essential for running MapReduce jobs, uploading files, and managing data.**

---

## 🎯 Quick Reference

| Task | Command |
|------|---------|
| **Access Hadoop NameNode bash** | `docker exec -it namenode bash` |
| **Access DataNode bash** | `docker exec -it datanode bash` |
| **Access Hive bash** | `docker exec -it hive-server bash` |
| **Access MySQL bash** | `docker exec -it mysql-db bash` |
| **Run Hadoop command** | `docker exec namenode hadoop fs -ls /` |
| **Run Hive query** | `docker exec -it hive-server hive` |
| **Run Pig script** | `docker exec -it namenode pig` |

---

## 🔗 Connecting to NameNode (Most Used)

The **NameNode** is your main entry point for Hadoop/HDFS work.

### Interactive Bash Terminal

```bash
docker exec -it namenode bash
```

This opens an **interactive bash shell** inside the NameNode container where you can:
- Run Hadoop commands
- Upload/download files
- Compile Java programs
- Create and run MapReduce jobs
- Check HDFS status

**Example session:**
```bash
$ docker exec -it namenode bash

# Now you're inside the container
root@namenode:/# hadoop fs -ls /
root@namenode:/# hadoop fs -mkdir /user
root@namenode:/# cd /tmp
root@namenode:/tmp# ls -la
root@namenode:/tmp# exit  # Exit when done
```

---

## 📤 Working with Files

### Copy File FROM Your PC TO Container

```bash
docker cp myfile.txt namenode:/tmp/myfile.txt
```

**Then in the container:**
```bash
docker exec -it namenode bash
root@namenode:/# ls -la /tmp/myfile.txt
root@namenode:/# cat /tmp/myfile.txt
```

### Copy File FROM Container TO Your PC

```bash
docker cp namenode:/tmp/result.txt ./result.txt
```

---

## 🎯 MapReduce Job Examples

### Compile Java MapReduce Job (Inside Container)

```bash
docker exec -it namenode bash

# Inside container:
root@namenode:/# cd /tmp
root@namenode:/tmp# javac -d . wordcount.java
root@namenode:/tmp# jar -cvf wordcount.jar *.class
root@namenode:/tmp# exit
```

### Run MapReduce Job

```bash
# First, copy your files to container
docker cp workspace/mapred/wordcount.jar namenode:/tmp/
docker cp workspace/mapred/input.txt namenode:/tmp/

# Then run the job inside container
docker exec namenode hadoop jar /tmp/wordcount.jar wordcount /tmp/input.txt /output

# Or run inside interactive terminal:
docker exec -it namenode bash
root@namenode:/# hadoop jar /tmp/wordcount.jar wordcount /tmp/input.txt /output
root@namenode:/# hadoop fs -cat /output/part-r-00000
```

---

## 🐘 Hadoop/HDFS Commands

### View HDFS Contents

```bash
# List root directory
docker exec namenode hadoop fs -ls /

# List user directory
docker exec namenode hadoop fs -ls /user

# List all files recursively
docker exec namenode hadoop fs -ls -R /
```

### Create Directory in HDFS

```bash
docker exec namenode hadoop fs -mkdir -p /user/mydata
```

### Upload File to HDFS

```bash
# First copy to container tmp
docker cp mydata.txt namenode:/tmp/

# Then upload to HDFS
docker exec namenode hadoop fs -put /tmp/mydata.txt /user/mydata.txt
```

### Download from HDFS

```bash
docker exec namenode hadoop fs -get /user/mydata.txt /tmp/mydata.txt
docker cp namenode:/tmp/mydata.txt ./mydata.txt
```

### View File Content in HDFS

```bash
docker exec namenode hadoop fs -cat /user/mydata.txt
```

### Delete Files from HDFS

```bash
docker exec namenode hadoop fs -rm /user/mydata.txt
docker exec namenode hadoop fs -rm -r /user/mydata/  # Recursive delete
```

### Check HDFS Status

```bash
docker exec namenode hadoop dfsadmin -report
docker exec namenode hadoop fs -df
docker exec namenode hadoop fs -count /
```

---

## 🐝 Hive Queries

### Open Hive Interactive Shell

```bash
docker exec -it hive-server hive
```

**Now you can run HiveQL commands:**
```
hive> SHOW DATABASES;
hive> USE default;
hive> SHOW TABLES;
hive> CREATE TABLE test (id INT, name STRING);
hive> SELECT * FROM test;
hive> quit;
```

### Run Single Hive Query (Non-Interactive)

```bash
docker exec hive-server hive -e "SELECT * FROM table_name LIMIT 10;"
```

### Run Hive Script File

First, copy your script to the container:
```bash
docker cp myscript.sql hive-server:/tmp/

# Then run it
docker exec hive-server hive -f /tmp/myscript.sql
```

### Example: Create Table from HDFS Data

```bash
docker exec -it hive-server hive

hive> CREATE EXTERNAL TABLE mydata (
    id INT,
    name STRING,
    age INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LOCATION '/user/mydata/';

hive> SELECT COUNT(*) FROM mydata;
hive> quit;
```

---

## 🐷 Pig Scripts

### Open Pig Interactive Shell

```bash
docker exec -it namenode pig
```

**Now you can enter Pig Latin commands:**
```
grunt> A = LOAD '/user/mydata.txt' AS (name, age);
grunt> B = FILTER A BY age > 30;
grunt> DUMP B;
grunt> quit;
```

### Run Pig Script File

First, copy your script:
```bash
docker cp myscript.pig namenode:/tmp/

# Then run it
docker exec namenode pig -f /tmp/myscript.pig
```

### Example: Simple Pig Job

```bash
docker exec -it namenode pig

grunt> data = LOAD '/user/input.txt' USING PigStorage(',') AS (name:chararray, age:int);
grunt> filtered = FILTER data BY age > 25;
grunt> STORE filtered INTO '/user/output' USING PigStorage(',');
grunt> quit;
```

---

## 🗄️ MySQL Database

### Access MySQL Shell

```bash
docker exec -it mysql-db mysql -u root -proot
```

**Now you can run SQL commands:**
```sql
mysql> SHOW DATABASES;
mysql> USE mydb;
mysql> SHOW TABLES;
mysql> SELECT * FROM users;
mysql> exit;
```

### Run Single SQL Query

```bash
docker exec mysql-db mysql -u root -proot -e "SELECT * FROM mydb.users;"
```

### Import SQL File

```bash
docker cp setup.sql mysql-db:/tmp/
docker exec mysql-db mysql -u root -proot < /tmp/setup.sql
```

---

## 🔗 Sqoop: SQL ↔ Hadoop Transfer

### Import MySQL Table to HDFS

```bash
docker exec namenode sqoop import \
  --connect jdbc:mysql://mysql-db:3306/mydb \
  --username root \
  --password root \
  --table users \
  --target-dir /user/users
```

### Export HDFS Data to MySQL

```bash
docker exec namenode sqoop export \
  --connect jdbc:mysql://mysql-db:3306/mydb \
  --username root \
  --password root \
  --table users \
  --export-dir /user/users
```

---

## 🔍 Container Status & Logs

### Check if Container is Running

```bash
docker ps | grep namenode
```

### View Container Logs

```bash
# View recent logs
docker logs namenode

# Follow live logs
docker logs -f namenode

# Last 50 lines
docker logs --tail 50 namenode
```

### Check Container Resource Usage

```bash
docker stats namenode
docker stats  # All containers
```

### Inspect Container Network

```bash
docker inspect namenode | grep -i ipaddress
docker network ls
```

---

## ⚠️ Common Issues & Solutions

### "docker exec: command not found"

**Problem**: Container not running
```bash
# Check if container exists
docker ps -a

# Start it
docker-compose up -d
```

### "Permission denied" in HDFS

**Problem**: HDFS file permissions
```bash
# Run as correct user
docker exec namenode hadoop fs -chmod 777 /path/to/file

# Or check owner
docker exec namenode hadoop fs -ls -la /
```

### "Connection refused" for Hive

**Problem**: HiveServer2 not started
```bash
# Check logs
docker logs hive-server

# Restart
docker-compose restart hive-server
```

### "No space left on device"

**Problem**: Docker disk full
```bash
# Check space
docker system df

# Clean up
docker system prune -a -f --volumes
```

### Java compilation errors in container

**Problem**: Wrong Java version or classpath
```bash
docker exec namenode java -version
docker exec namenode javac -version

# Check HADOOP_CLASSPATH
docker exec namenode echo $HADOOP_CLASSPATH
```

---

## 🎯 Workflow: Complete Example

### Step 1: Create MapReduce Program Locally

Create `workspace/mapred/WordCount.java`:
```java
// Your MapReduce code here
```

### Step 2: Copy to Container & Compile

```bash
docker cp workspace/mapred/WordCount.java namenode:/tmp/
docker exec -it namenode bash

# Inside container:
root@namenode:/# cd /tmp
root@namenode:/tmp# javac -d . WordCount.java
root@namenode:/tmp# jar -cvf wordcount.jar *.class
root@namenode:/tmp# exit
```

### Step 3: Prepare Input Data

```bash
docker exec namenode hadoop fs -mkdir -p /user/input
docker cp workspace/mapred/input.txt namenode:/tmp/
docker exec namenode hadoop fs -put /tmp/input.txt /user/input/
```

### Step 4: Run MapReduce Job

```bash
docker exec namenode hadoop jar /tmp/wordcount.jar WordCount /user/input /user/output
```

### Step 5: Check Results

```bash
docker exec namenode hadoop fs -cat /user/output/part-r-00000
```

### Step 6: Copy Results to Local

```bash
docker cp namenode:/user/output ./workspace/outputs
```

---

## 🎓 Key Concepts

**Why use `docker exec -it`?**
- `-i` = interactive (keep STDIN open)
- `-t` = terminal (allocate pseudo-terminal)
- Together: lets you type commands and see output

**Containers vs Your PC:**
- Containers: ephemeral (temporary), inside Docker
- Your PC: persistent (permanent), local filesystem
- Use `docker cp` to transfer files

**HDFS vs Local Filesystem:**
- Local filesystem: `/tmp/`, `/root/`, inside container
- HDFS: `/user/`, `/data/`, distributed storage
- Use `hadoop fs` for HDFS operations

---

## 🔗 Related Guides

- **QUICK_START.md** - Get running in 3 commands
- **LAB_EXPERIMENTS.md** - 8 complete experiments
- **SETUP_GUIDE.md** - Detailed setup & troubleshooting
- **QUICK_REFERENCE.txt** - Command cheatsheet

---

## ✅ You're Ready!

You now know how to:
- ✅ Access container bash terminals
- ✅ Run Hadoop/HDFS commands
- ✅ Upload/download files
- ✅ Compile and run MapReduce jobs
- ✅ Query with Hive and Pig
- ✅ Transfer data with Sqoop
- ✅ Handle common issues

**Next**: Try your first MapReduce job in LAB_EXPERIMENTS.md!


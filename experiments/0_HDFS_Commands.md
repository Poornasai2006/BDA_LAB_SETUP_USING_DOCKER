# 🗄️ Experiment 0: HDFS Commands Fundamentals

## 🛠️ **Tool: Hadoop HDFS (Hadoop Distributed File System)**

**What is HDFS?**
- Distributed file system for Hadoop
- Stores large files across multiple machines
- **Use Case**: Foundation for all big data operations - uploading, managing, and querying data
- **Key Concepts**: NameNode, DataNode, blocks, replication, HDFS commands

---

## 🎯 Objective

Master essential HDFS commands to manage files in the distributed file system. This is **FUNDAMENTAL** - you need these commands for every other experiment.

---

## ⚠️ IMPORTANT

**This should be Experiment 0 (first thing to learn)**. All other experiments depend on HDFS commands!

---

## 📋 Steps

### Step 1: Access NameNode Terminal

```bash
docker exec -it namenode bash
```

You're now inside the Hadoop NameNode container.

---

## 📂 HDFS File System Structure

HDFS root: `/`

**Common directories:**
- `/` - HDFS root
- `/user/` - User home directories
- `/tmp/` - Temporary files
- `/data/` - Data storage

---

## 🔍 **1. Listing Files & Directories**

### Basic Listing

```bash
# List files in HDFS root
hadoop fs -ls /

# List with more details
hadoop fs -ls -l /

# List recursively (all subdirectories)
hadoop fs -ls -R /

# List specific directory
hadoop fs -ls /user
```

**Example Output:**
```
drwxr-xr-x   - root supergroup          0 2024-01-15 10:30 /user
-rw-r--r--   1 root supergroup      1024 2024-01-15 10:25 /test.txt
```

---

## 📤 **2. Uploading Files to HDFS**

### Method 1: Upload from Container Filesystem

```bash
# First, copy file to container
docker cp /path/to/local/file.txt namenode:/tmp/

# Then put it in HDFS
hadoop fs -put /tmp/file.txt /file.txt

# Verify upload
hadoop fs -ls / | grep file.txt
```

### Method 2: Direct Upload from Your PC

```bash
# From your PC (outside container)
docker cp mydata.txt namenode:/tmp/
docker exec namenode hadoop fs -put /tmp/mydata.txt /mydata.txt
```

### Upload Examples

```bash
# Upload single file
hadoop fs -put /tmp/input.txt /input.txt

# Upload directory (recursive)
hadoop fs -put /tmp/data_folder /data_folder

# Upload and overwrite if exists
hadoop fs -put -f /tmp/file.txt /file.txt
```

---

## 📥 **3. Downloading Files from HDFS**

### Download to Container, Then to Your PC

```bash
# Download from HDFS to container filesystem
hadoop fs -get /myfile.txt /tmp/myfile.txt

# Copy from container to your PC
docker cp namenode:/tmp/myfile.txt ./myfile.txt
```

### Direct Example

```bash
# Download output results
hadoop fs -get /output /tmp/output
docker cp namenode:/tmp/output ./local_output
```

---

## 📄 **4. Viewing File Content**

### View Small Files

```bash
# View entire file content
hadoop fs -cat /file.txt

# View first N lines
hadoop fs -head /file.txt

# View last N bytes
hadoop fs -tail /file.txt
```

### View MapReduce Output

```bash
# View job output
hadoop fs -cat /output/part-r-00000

# View multiple output files
hadoop fs -cat /output/*
```

---

## 📁 **5. Creating Directories**

```bash
# Create single directory
hadoop fs -mkdir /mydir

# Create nested directories
hadoop fs -mkdir -p /user/data/input
hadoop fs -mkdir -p /user/data/output

# Verify creation
hadoop fs -ls /user/data/
```

---

## ✏️ **6. File Operations**

### Copy Files

```bash
# Copy within HDFS
hadoop fs -cp /source/file.txt /destination/file.txt

# Copy directory
hadoop fs -cp -r /source_dir /dest_dir
```

### Move/Rename Files

```bash
# Rename file
hadoop fs -mv /old_name.txt /new_name.txt

# Move file to directory
hadoop fs -mv /file.txt /new_directory/

# Move directory
hadoop fs -mv /old_dir /new_dir
```

### Delete Files

```bash
# Delete single file
hadoop fs -rm /file.txt

# Delete directory (recursive)
hadoop fs -rm -r /directory

# Force delete without prompt
hadoop fs -rm -f /file.txt
hadoop fs -rm -rf /directory
```

---

## 📊 **7. File Information**

### Check File Status

```bash
# Get file details
hadoop fs -stat /file.txt

# Output format: %b (size), %y (modification time)
hadoop fs -stat "%b %y" /file.txt
```

### Count Files and Directories

```bash
# Count files in directory
hadoop fs -count /directory

# Count recursively
hadoop fs -count -q /directory
```

### Check File Size

```bash
# Get size of file
hadoop fs -du /file.txt

# Get total size of directory
hadoop fs -du -s /directory

# Get size in human readable format
hadoop fs -du -sh /directory
```

---

## 🔐 **8. File Permissions & Ownership**

### Change Permissions

```bash
# Change file permissions (777 = read/write/execute for all)
hadoop fs -chmod 777 /file.txt

# Change directory permissions recursively
hadoop fs -chmod -R 755 /directory
```

### Change Owner

```bash
# Change file owner
hadoop fs -chown user:group /file.txt

# Change directory owner recursively
hadoop fs -chown -R user:group /directory
```

---

## 🧹 **9. HDFS Health Check**

### Check HDFS Status

```bash
# View HDFS health report
hadoop dfsadmin -report

# Check NameNode status
hadoop fsck /

# Check specific file replication
hadoop fsck /file.txt -files -blocks
```

### Disk Space Usage

```bash
# Check available disk space
hadoop fs -df

# Check directory size
hadoop fs -du -s -h /

# List top-level directory sizes
hadoop fs -du -s -h /*/
```

---

## 📝 **10. Common Workflows**

### Workflow 1: Upload and List

```bash
# Upload file
docker cp mydata.txt namenode:/tmp/
hadoop fs -put /tmp/mydata.txt /mydata.txt

# List to verify
hadoop fs -ls /

# View content
hadoop fs -cat /mydata.txt
```

### Workflow 2: Process and Download

```bash
# Check processed output
hadoop fs -ls /output/

# View results
hadoop fs -cat /output/part-r-00000

# Download to local
hadoop fs -get /output /tmp/results
docker cp namenode:/tmp/results ./results_local
```

### Workflow 3: Cleanup

```bash
# Remove old files
hadoop fs -rm -r /old_data

# Verify deletion
hadoop fs -ls /
```

---

## 🐛 **Troubleshooting**

### File Not Found

```bash
# Check if file exists
hadoop fs -test -e /file.txt && echo "exists" || echo "not found"

# List directory contents
hadoop fs -ls /path/to/directory
```

### Permission Denied

```bash
# Check file permissions
hadoop fs -ls -la /file.txt

# Fix permissions
hadoop fs -chmod 777 /file.txt

# Or change owner if needed
hadoop fs -chown $USER /file.txt
```

### Disk Full

```bash
# Check HDFS disk usage
hadoop fs -df -h

# Find large files
hadoop fs -du -s -h /data/* | sort -h -r | head -10

# Delete unnecessary files
hadoop fs -rm -r /old_files
```

### Replication Issues

```bash
# Check file replication status
hadoop fsck /file.txt

# Fix under-replicated blocks
hadoop fsck / -files -blocks -locations | grep UNDER_REPLICATED

# Check rack awareness
hdfs dfsadmin -printTopology
```

---

## 📋 **Quick Reference Table**

| Command | Purpose |
|---------|---------|
| `hadoop fs -ls /` | List files |
| `hadoop fs -put file /` | Upload file |
| `hadoop fs -get /file file` | Download file |
| `hadoop fs -cat /file` | View file content |
| `hadoop fs -mkdir /dir` | Create directory |
| `hadoop fs -rm /file` | Delete file |
| `hadoop fs -rm -r /dir` | Delete directory |
| `hadoop fs -cp /src /dst` | Copy file |
| `hadoop fs -mv /src /dst` | Move/rename |
| `hadoop fs -chmod 777 /file` | Change permissions |
| `hadoop fs -du -s /dir` | Check directory size |
| `hadoop dfsadmin -report` | Check HDFS status |
| `hadoop fsck /` | Check file system health |

---

## 💡 **Key Concepts**

### HDFS Architecture
- **NameNode**: Manages file system namespace, maintains file system tree
- **DataNode**: Stores actual data, performs block creation/deletion
- **Replication**: Files split into blocks, replicated across nodes
- **Rack Awareness**: Replicas placed for fault tolerance

### File Paths
- Absolute: `/user/data/file.txt` (starts with `/`)
- Relative: Not commonly used in HDFS
- Home directory: `/user/username/`

### Permissions
- Format: `rwx` (read/write/execute) for owner, group, others
- Example: `755` = owner full, group read/execute, others read/execute

---

## ✅ **Verification Checklist**

After practicing HDFS commands:

- [ ] Can list files with `hadoop fs -ls`
- [ ] Can upload files with `hadoop fs -put`
- [ ] Can download files with `hadoop fs -get`
- [ ] Can view content with `hadoop fs -cat`
- [ ] Can create directories with `hadoop fs -mkdir`
- [ ] Can delete files/directories with `hadoop fs -rm`
- [ ] Can copy files with `hadoop fs -cp`
- [ ] Can move/rename files with `hadoop fs -mv`
- [ ] Understand file permissions
- [ ] Can check HDFS health with `hadoop dfsadmin -report`

---

## 🎯 Next Experiment

These HDFS commands are essential! After mastering them, proceed to:
- **Experiment 1**: MapReduce WordCount (uses HDFS for input/output)
- **Experiment 2**: Hive SQL Queries (loads data from HDFS)

---

## 📞 Getting Help

- HDFS commands: `hadoop fs -help`
- Specific command: `hadoop fs -help ls`
- Check Hadoop logs: `docker logs namenode`

---

**Status**: ✅ Complete | **Difficulty**: Beginner | **Time**: 10-15 minutes | **Prerequisite**: None (Start here!)


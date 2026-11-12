# ⚡ Quick Start - 3 Commands to Run Your Lab

Everything is now **fully automatic**. No manual configuration needed!

---

## 🚀 Three Simple Steps

### Step 1: Build (10-15 minutes)
```bash
docker build -t local/hadoop-namenode-sqoop:2.7.4 .
```

**What happens:**
- Downloads Sqoop automatically
- Downloads Pig automatically
- Downloads MySQL connector automatically
- Installs everything
- Creates Docker image

**Output:** `Successfully tagged local/hadoop-namenode-sqoop:2.7.4`

### Step 2: Start Services (2-3 minutes)
```bash
docker-compose up -d
```

**What happens:**
- Starts all 8 containers
- Sets up networking
- Configures metastores
- Services auto-connect

**Output:** Several "container started" messages

### Step 3: Verify (1 minute)
```bash
docker-compose ps
```

**Expected output:**
```
CONTAINER ID   IMAGE                    STATUS      NAMES
xxx            hadoop-namenode          Up 1 min    namenode
xxx            hadoop-datanode          Up 1 min    datanode
xxx            hadoop-resourcemanager   Up 1 min    resourcemanager
xxx            hadoop-nodemanager       Up 1 min    nodemanager
xxx            hadoop-historyserver     Up 1 min    historyserver
xxx            hive-metastore           Up 1 min    hive-metastore
xxx            hive-server              Up 1 min    hive-server
xxx            mysql                    Up 1 min    mysql-db
```

**Status:** ✅ All containers UP - Lab is ready!

---

## 🎯 Your Lab is Now Running!

Access these services:

| Service | URL/Command | Port |
|---------|------------|------|
| **NameNode UI** | http://localhost:50070 | 50070 |
| **YARN UI** | http://localhost:8088 | 8088 |
| **History Server** | http://localhost:8188 | 8188 |
| **HiveServer2** | `docker exec -it hive-server hive` | 10000 |
| **Pig** | `docker exec -it namenode pig` | N/A |
| **MySQL** | `mysql -h localhost -P 3307 -u root -proot` | 3307 |

---

## 📊 Build Time Breakdown

### First Build (~10-15 min)
- Base image pull: 2-3 min
- Sqoop download: 2-3 min
- Pig download: 2-3 min
- MySQL connector: 30 sec
- Build & install: 2-3 min

### Subsequent Builds (~2-3 min)
- Docker caches layers
- Only rebuilds if Dockerfile changes
- Much faster!

---

## ✅ That's It!

No manual work. No configuration. Just 3 commands!

---

## 🛑 When You're Done

### Stop (Keep Data)
```bash
docker-compose down
```

### Remove Everything
```bash
docker-compose down -v
```

---

## 📚 For More Details

- **Full Setup Guide**: See `SETUP_GUIDE.md`
- **Troubleshooting**: See `SETUP_GUIDE.md` → Troubleshooting section
- **Commands Cheatsheet**: See `QUICK_REFERENCE.txt`
- **What Changed**: See `DOCKER_IMPROVEMENTS.md`
- **How to Backup**: See `BACKUP_INFO.md`

---

## 🎓 What You Have

After these 3 commands:

✅ **Hadoop 2.7.4** - Distributed file system  
✅ **YARN** - Job scheduling  
✅ **Hive 2.3.2** - SQL interface  
✅ **Pig 0.17.0** - Data processing  
✅ **Sqoop 1.4.7** - Data import/export  
✅ **MySQL 5.7** - Sample database  
✅ **PostgreSQL** - Hive metadata backend  

**All automatically configured and running!** 🚀

---

## 🎉 Ready to Go!

Your big data analytics lab is ready to use.

Enjoy! ✨

# 🐳 Big Data Analytics Lab - Docker Setup

A complete, production-ready big data analytics lab using Docker containers. Automates deployment of Hadoop, Hive, Pig, Sqoop, MySQL, and PostgreSQL with zero manual configuration.

**Perfect for**: College labs, learning, data engineering projects, and team training.

---

## ⚡ Quick Start (3 Steps)

### Step 1: Clone & Setup
```bash
# Clone repository
git clone <your-repo-url>
cd hadoop-docker

# Create workspace directory for your data and programs
mkdir -p workspace/mapred
mkdir -p workspace/pig_scripts
mkdir -p workspace/outputs
```

### Step 2: Build Docker Image
```bash
# Builds image with Sqoop, Pig, MySQL connector (auto-downloaded)
docker build -t local/hadoop-namenode-sqoop:2.7.4 .
```
**Time**: ~10-15 minutes (one-time only)

### Step 3: Start Services
```bash
# Start all 8 services
docker-compose up -d

# Verify all containers running
docker-compose ps
```
**Time**: ~2-3 minutes

---

## 🎯 Access Your Lab

| Service | URL | Port | Command |
|---------|-----|------|---------|
| NameNode Web UI | http://localhost:50070 | 50070 | - |
| YARN UI | http://localhost:8088 | 8088 | - |
| History Server | http://localhost:8188 | 8188 | - |
| HiveServer2 | - | 10000 | `docker exec -it hive-server hive` |
| MySQL | localhost | 3307 | `docker exec -it mysql-db mysql -u root -proot` |
| Pig | - | - | `docker exec -it namenode pig` |

---

## 📂 Project Structure

```
hadoop-docker/
├── README.md                    # This file
├── QUICK_START.md              # 3 commands reference
├── SETUP_GUIDE.md              # Detailed setup & troubleshooting
├── LAB_EXPERIMENTS.md          # 8 ready-to-run experiments
├── QUICK_REFERENCE.txt         # Docker & Hadoop commands
│
├── docker-compose.yml          # Services configuration
├── Dockerfile                  # Custom image with Sqoop & Pig
├── hadoop-hive.env             # Environment variables
├── .gitignore                  # Git ignore rules
└── LICENSE                     # MIT License

workspace/                       # ⚠️ NOT in repo - YOU CREATE THIS
├── mapred/                     # Your MapReduce jobs (.java, .jar)
├── pig_scripts/                # Your Pig scripts (.pig)
└── outputs/                    # Job output files
```

### ⚠️ Important: Create `workspace/` Directory

The `workspace/` directory is **not included** in the repository. Users must create it after cloning:

```bash
# Create after cloning
mkdir -p workspace/mapred
mkdir -p workspace/pig_scripts
mkdir -p workspace/outputs
```

This keeps your code and data separate, clean, and portable.

---

## 🐳 What's Included

### Big Data Tools (Auto-Installed)
- ✅ **Hadoop 2.7.4** - Distributed computing framework
- ✅ **HDFS** - Distributed file storage
- ✅ **YARN** - Job scheduling and resource management
- ✅ **Hive 2.3.2** - SQL queries on big data
- ✅ **Pig 0.17.0** - Data transformation (ETL)
- ✅ **Sqoop 1.4.7** - SQL ↔ Hadoop data transfer
- ✅ **MySQL 5.7** - Sample relational database
- ✅ **PostgreSQL** - Hive metadata backend

### Services (8 Containers)
1. NameNode (HDFS Master)
2. DataNode (HDFS Storage)
3. ResourceManager (YARN Scheduler)
4. NodeManager (YARN Worker)
5. HistoryServer (Job History)
6. HiveServer2 (SQL Interface)
7. Hive Metastore (Metadata)
8. MySQL (Sample Database)

---

## 🧪 Lab Experiments

8 complete experiments included (see `LAB_EXPERIMENTS.md`):

1. **MapReduce WordCount** - Distributed word counting
2. **Hive SQL Queries** - SQL on distributed data
3. **Pig Data Processing** - ETL transformations
4. **Sqoop Import** - MySQL → HDFS
5. **Hive External Tables** - Tables on HDFS
6. **Join Operations** - Multi-table queries
7. **Pig with Joins** - Complex transformations
8. **Data Aggregation** - Group by and statistics

Each experiment includes:
- ✅ Step-by-step instructions
- ✅ Sample data
- ✅ Expected output
- ✅ Docker commands

---

## 📚 Documentation

| File | Purpose |
|------|---------|
| **QUICK_START.md** | 3 commands to run the lab |
| **CONTAINER_ACCESS.md** | ⭐ **START HERE** - Access bash, run commands in containers |
| **SETUP_GUIDE.md** | Detailed setup and troubleshooting |
| **LAB_EXPERIMENTS.md** | 8 complete experiments with examples |
| **QUICK_REFERENCE.txt** | Docker & Hadoop commands cheatsheet |
| **CLEANUP_GUIDE.md** | Remove containers and clean up system |

---

## 🔧 Common Tasks

### ⭐ Access Hadoop Terminal

```bash
# Enter NameNode bash (do this to run Hadoop/HDFS commands)
docker exec -it namenode bash

# Now you can run commands like:
# hadoop fs -ls /
# hadoop jar job.jar input output
# cd /tmp && javac MapReduce.java
```

**⚠️ IMPORTANT**: Most Hadoop/HDFS commands must run **inside** the container using `docker exec -it namenode bash`. See **CONTAINER_ACCESS.md** for complete guide.

### Upload File to HDFS
```bash
docker cp myfile.txt namenode:/tmp/
docker exec namenode hadoop fs -put /tmp/myfile.txt /myfile.txt
```

### View HDFS Contents
```bash
docker exec namenode hadoop fs -ls /
docker exec namenode hadoop fs -cat /file.txt
```

### Query with Hive (CORRECT WAY)
```bash
docker exec -it hive-server hive
# Then in Hive shell:
# hive> SELECT * FROM table;
# hive> quit;
```

### Transform with Pig
```bash
docker exec -it namenode pig
# Or run script:
docker exec namenode pig -f /tmp/script.pig
```

### Stop/Start Services
```bash
docker-compose stop      # Stop (keep data)
docker-compose start     # Resume
docker-compose down      # Stop everything
docker-compose down -v   # Stop and delete volumes
```

---

## 🧹 Cleanup & Remove

When you're done with the lab, see **CLEANUP_GUIDE.md** for detailed instructions.

### Quick Cleanup Options

**Pause for today:**
```bash
docker-compose stop
```

**Full shutdown (remove containers & volumes):**
```bash
docker-compose down -v
```

**Complete cleanup (remove images too):**
```bash
docker system prune -a -f --volumes
```

**⚠️ Important**: Backup your `workspace/` folder before cleanup if you have important results!

---

## ✅ Prerequisites

- ✅ **Docker** (v20.10+) - [Install](https://docs.docker.com/get-docker/)
- ✅ **Docker Compose** (v1.29+) - Usually included with Docker
- ✅ **4GB+ RAM** - Allocated to Docker
- ✅ **10GB+ Free Disk Space** - For images and containers
- ✅ **Internet Connection** - For downloading base images & binaries (first time only)

### Check Prerequisites
```bash
docker --version
docker-compose --version
docker ps
```

---

## 🚀 Workflow

### First Time Setup
```bash
git clone <repo>          # 1 min
cd hadoop-docker          # -
mkdir workspace/*         # 1 min
docker build ...          # 10-15 min
docker-compose up -d      # 2-3 min
docker-compose ps         # Verify
# ✅ Lab ready!
```

### Subsequent Uses
```bash
docker-compose up -d      # 2-3 min
# Lab ready immediately!
```

### When Done
```bash
docker-compose down       # Stop (keep data)
docker-compose down -v    # Stop and clean
```

---

## 🐛 Troubleshooting

### Containers not starting?
```bash
docker-compose logs namenode
docker-compose logs hive-server
```

### Hive connection failed?
```bash
docker exec hive-server ps aux | grep hive
docker-compose restart hive-server
```

### Out of memory?
Increase Docker memory in Docker Desktop settings (Preferences → Resources)

### Port already in use?
```bash
# Check what's using port
netstat -ano | findstr :50070

# Or use different port in docker-compose.yml
# Change "50070:50070" to "50071:50070"
```

See **SETUP_GUIDE.md** for more troubleshooting.

---

## 📋 Data Persistence

### Volumes (Automatic)
Data is saved in Docker volumes. Even after `docker-compose down`, volumes persist:

```bash
docker-compose down     # Containers stop, data remains
docker-compose up -d    # Data still there!
```

### Workspace Directory
Your programs and scripts in `workspace/` are on your local machine:

```bash
workspace/
├── mapred/              # Your .java and .jar files
├── pig_scripts/         # Your .pig scripts
└── outputs/             # Your results
```

### Full Cleanup (Warning!)
```bash
docker-compose down -v   # ⚠️ Deletes volumes!
```

---

## 🎓 Learning Path

### Beginner
1. Run QUICK_START.md
2. Access NameNode UI
3. Try Experiment 1 (MapReduce)
4. Try Experiment 2 (Hive)

### Intermediate
1. Write custom MapReduce job
2. Create Hive tables and queries
3. Try Pig transformations
4. Import MySQL data with Sqoop

### Advanced
1. Complex MapReduce programs
2. Hive joins and aggregations
3. Pig ETL pipelines
4. End-to-end data workflows

---

## 📚 Resources

- [Hadoop Documentation](https://hadoop.apache.org/)
- [Hive Language Manual](https://cwiki.apache.org/confluence/display/Hive)
- [Pig Latin Reference](https://pig.apache.org/docs/r0.17.0/basic.html)
- [Sqoop User Guide](https://sqoop.apache.org/docs/1.4.7/SqoopUserGuide.html)
- [Docker Documentation](https://docs.docker.com/)

---

## 📄 License

MIT License - See LICENSE file

---

## 🎯 Next Steps

1. **Read**: QUICK_START.md (2 minutes)
2. **Build**: `docker build -t local/hadoop-namenode-sqoop:2.7.4 .` (15 minutes)
3. **Run**: `docker-compose up -d` (3 minutes)
4. **Explore**: LAB_EXPERIMENTS.md

**Your big data lab is ready!** 🚀

---

**Status**: ✅ Production Ready | **Version**: 1.0 | **Last Updated**: 2026

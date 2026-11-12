# 🚀 First Time Setup

After cloning this repository, follow these simple steps:

## Step 1: Create Workspace Directory

```bash
# Create folders for your data and programs
mkdir -p workspace/mapred
mkdir -p workspace/pig_scripts
mkdir -p workspace/outputs
```

**What is this for?**
- `workspace/mapred/` - Your MapReduce Java programs (.java, .jar files)
- `workspace/pig_scripts/` - Your Pig scripts (.pig files)
- `workspace/outputs/` - Output results from jobs

## Step 2: Build Docker Image

```bash
# Build custom image with Sqoop, Pig, MySQL connector
docker build -t local/hadoop-namenode-sqoop:2.7.4 .
```

**Time**: ~10-15 minutes (first time only)  
**What happens**:
- Downloads base Hadoop image
- Downloads Sqoop (~150 MB)
- Downloads Pig (~200 MB)
- Downloads MySQL connector (~4 MB)
- Installs and configures everything

## Step 3: Start Services

```bash
# Start all 8 services
docker-compose up -d

# Verify all containers are running
docker-compose ps
```

**Time**: ~2-3 minutes  
**You should see**: 8 containers all in "Up" status

## Step 4: Access Your Lab

### Web Interfaces
- **NameNode UI**: http://localhost:50070
- **YARN ResourceManager**: http://localhost:8088
- **Job History**: http://localhost:8188

### Command Line Tools

```bash
# Hive (SQL queries)
docker exec -it hive-server hive

# Pig (Data transformation)
docker exec -it namenode pig

# MySQL (Database)
docker exec -it mysql-db mysql -u root -proot

# Hadoop commands
docker exec namenode hadoop fs -ls /
```

---

## 📚 Next Steps

1. Read **README.md** - Full documentation
2. See **QUICK_START.md** - 3 commands reference
3. Try **LAB_EXPERIMENTS.md** - 8 ready-to-run experiments
4. Use **QUICK_REFERENCE.txt** - Common commands

---

## ✅ Done!

Your big data lab is ready to use! 🎉

---

## ❓ Troubleshooting

**Container won't start?**
```bash
docker-compose logs namenode
```

**Want to stop?**
```bash
docker-compose down     # Stop (keep data)
docker-compose down -v  # Stop and clean
```

**Want to start again?**
```bash
docker-compose up -d
```

That's it! See README.md for more details.

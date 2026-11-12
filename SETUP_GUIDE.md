# Quick Setup Guide - Recreating the Lab

## For Future Reference: Step-by-Step Recreation

### What You Need to Preserve

To recreate this entire Hadoop ecosystem setup, save these files:

```
1. Core Configuration Files:
   - docker-compose.yml
   - Dockerfile
   - hadoop-hive.env
   - README.md (this guide)
   - SETUP_GUIDE.md

2. External Binaries (place in workspace/):
   - sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz
   - pig-0.17.0.tar.gz
   - mysql-connector-java-5.1.49.jar
```

### Prerequisites Before Building

Make sure you have:
- ✅ Docker installed (version 20.10 or later)
- ✅ Docker Compose installed (version 1.29 or later)
- ✅ At least 4GB RAM allocated to Docker
- ✅ 10GB+ free disk space
- ✅ Stable internet connection (for automatic downloads)

**Note**: No manual binary downloads needed! Everything downloads automatically during docker build.

### Build & Run Instructions

#### Step 1: Prepare the workspace directory
```bash
cd hadoop-docker
mkdir -p workspace
# Workspace can be empty - binaries download automatically!
```

#### Step 2: Build the custom Docker image
```bash
docker build -t local/hadoop-namenode-sqoop:2.7.4 .
```

**What happens**:
- Downloads Sqoop, Pig, MySQL connector automatically
- Extracts and installs them
- Configures environment variables
- Creates custom image

**Time**: 10-15 minutes (first time, includes binary downloads)

Expected output: `Successfully tagged local/hadoop-namenode-sqoop:2.7.4`

⏱️ **Note**: First build takes longer due to downloads. Subsequent builds are faster (Docker caches layers).

#### Step 3: Start all containers
```bash
docker-compose up -d
```

#### Step 4: Wait for services to stabilize
```bash
# Check status (wait until all show "Up")
docker-compose ps

# Or follow logs
docker-compose logs -f
```

Typical startup time: 1-2 minutes

#### Step 5: Verify services are healthy

```bash
# Test NameNode (port 50070)
curl http://localhost:50070

# Test YARN ResourceManager (port 8088)
curl http://localhost:8088

# Test HiveServer2 (port 10000)
docker exec namenode nc -zv localhost 10000

# Test MySQL (port 3307)
docker exec mysql-db mysql -u root -proot -e "SHOW DATABASES;"
```

---

## Common Operations

### Upload a file to HDFS
```bash
# Copy file to container
docker cp myfile.txt namenode:/tmp/myfile.txt

# Put file in HDFS
docker exec namenode hadoop fs -put /tmp/myfile.txt /myfile.txt

# List HDFS contents
docker exec namenode hadoop fs -ls /
```

### Run a MapReduce job
```bash
# Copy compiled jar to container
docker cp wordcount.jar namenode:/tmp/

# Run the job
docker exec namenode hadoop jar /tmp/wordcount.jar wordcount /input /output

# Check output
docker exec namenode hadoop fs -cat /output/part-r-00000
```

### Import data with Sqoop
```bash
docker exec namenode sqoop import \
  --connect jdbc:mysql://mysql-db:3306/testdb \
  --username root \
  --password root \
  --table tablename \
  -m 1 \
  --target-dir /sqoop_import/tablename
```

### Query data with Hive
```bash
# Enter Hive shell (CORRECT WAY)
docker exec -it hive-server hive

# Sample query
> CREATE TABLE test (id INT, name STRING);
> INSERT INTO test VALUES (1, 'sample');
> SELECT * FROM test;
> quit;
```

### Run Pig script
```bash
# Create a pig script
echo "A = LOAD '/input' AS (line:chararray);
      B = FOREACH A GENERATE FLATTEN(TOKENIZE(line)) AS word;
      C = GROUP B BY word;
      D = FOREACH C GENERATE group, COUNT(B);
      STORE D INTO '/pig_output';" > script.pig

# Copy and run
docker cp script.pig namenode:/tmp/
docker exec namenode pig /tmp/script.pig
```

---

## Stopping & Cleanup

### Temporarily stop (preserves data)
```bash
docker-compose stop
```

### Resume after stopping
```bash
docker-compose start
```

### Complete shutdown (removes containers, preserves volumes)
```bash
docker-compose down
```

### Full cleanup (removes everything including volumes)
```bash
docker-compose down -v
```

### Remove only the custom image
```bash
docker rmi local/hadoop-namenode-sqoop:2.7.4
```

---

## Troubleshooting

### "docker: command not found"
- Docker is not installed. Download from docker.com

### "Cannot connect to Docker daemon"
- Docker daemon not running. Start Docker Desktop

### Containers keep restarting
```bash
# View error logs
docker-compose logs namenode
docker-compose logs hive-server
```

### Out of memory errors
- Increase Docker's memory allocation (Docker Desktop > Settings > Resources)
- Or reduce YARN memory in `hadoop-hive.env`:
  ```
  YARN_CONF_yarn_nodemanager_resource_memory___mb=512  (was 1024)
  ```

### Port already in use
```bash
# Find what's using the port (Windows example)
netstat -ano | findstr :50070

# Kill the process (replace PID)
taskkill /PID <PID> /F

# Or use different ports in docker-compose.yml
# Change "50070:50070" to "50071:50070" for example
```

### Hive connection refused
- Ensure hive-metastore is running first
```bash
docker-compose ps
# hive-metastore should show "Up"

# If not, restart:
docker-compose restart hive-metastore
```

### MySQL connection issues
- Check MySQL is running:
```bash
docker exec mysql-db mysql -u root -proot -e "SELECT 1;"
```

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────┐
│                    Docker Compose                        │
├─────────────────────────────────────────────────────────┤
│                                                           │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐   │
│  │  NameNode    │  │  DataNode    │  │ ResourceMgr  │   │
│  │ (Port 8020)  │  │ (Port 50075) │  │ (Port 8088)  │   │
│  └──────────────┘  └──────────────┘  └──────────────┘   │
│         │                │                    │           │
│         └────────────────┴────────────────────┘           │
│                      HDFS & YARN                         │
│                                                           │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐   │
│  │ NodeManager  │  │HistoryServer │  │  HiveServer  │   │
│  │ (Port 8042)  │  │ (Port 8188)  │  │ (Port 10000) │   │
│  └──────────────┘  └──────────────┘  └──────────────┘   │
│                                                           │
│  ┌──────────────┐  ┌──────────────┐                     │
│  │Hive Metastore│  │    MySQL     │                     │
│  │(Port 9083)   │  │  (Port 3307) │                     │
│  └──────────────┘  └──────────────┘                     │
│         │                │                                │
│      PostgreSQL        (testdb)                          │
│      (metadata)                                          │
│                                                           │
│  Mounted Volume: ./workspace                            │
│  ├── mapred/          (MapReduce jobs)                  │
│  ├── pig-0.17.0/      (Pig installation)                │
│  └── jars             (Sqoop, connectors)               │
│                                                           │
└─────────────────────────────────────────────────────────┘
```

---

## File Descriptions

### docker-compose.yml
- Defines all services (containers) and their configuration
- Maps ports for accessing web UIs
- Sets up volume mounts and networking
- Configures service dependencies

### Dockerfile
- Extends the base Hadoop NameNode image
- Installs Sqoop and Pig from compressed archives
- Sets environment variables for these tools
- Creates the custom `local/hadoop-namenode-sqoop:2.7.4` image

### hadoop-hive.env
- Configuration parameters for Hadoop cluster
- HDFS, YARN, and Hive settings
- Metastore connection details
- Resource allocation (memory, CPU cores)

### workspace/
- Local directory mounted to all containers
- Store your job files, scripts, and data here
- Changes persist even after container restart

---

## Backup Strategy

To preserve this setup:

1. **Commit this entire directory to version control (Git)**
   ```bash
   git init
   git add .
   git commit -m "Big Data Lab - Hadoop/Hive/Pig/Sqoop Docker Setup"
   git remote add origin <your-repo-url>
   git push -u origin main
   ```

2. **Keep workspace/ directory backed up**
   - Contains your job outputs and data
   - Important for reproducibility

3. **Document any custom configurations**
   - If you modified hadoop-hive.env, note the changes
   - Include your customized scripts

4. **Tag your commit with version**
   ```bash
   git tag -a v1.0-final -m "Lab submission version"
   git push origin v1.0-final
   ```

---

## Next Steps When You Need to Use This Again

1. Clone the repository (or unzip this directory)
2. Ensure Docker is installed and running
3. Follow **Build & Run Instructions** section above
4. Your entire lab environment will be ready in 2-3 minutes

---

**Note**: All data from running containers is stored in Docker volumes. After `docker-compose down`, the data persists until you explicitly run `docker-compose down -v`.

To preserve workspace data permanently, regularly back up the `workspace/` directory.

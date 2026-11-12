# 🧹 Cleanup Guide - Remove Docker Lab

This guide explains how to stop, remove, and clean up your Big Data Analytics Lab when you're done.

---

## ⚠️ Before You Clean Up

**Make sure to backup important data:**
```bash
# Backup your workspace
cp -r workspace workspace-backup

# Or compress it
tar -czf workspace-backup.tar.gz workspace/
```

---

## 🛑 Option 1: Stop Containers (Keep Data)

Use this if you want to pause the lab but keep your data and containers.

```bash
# Stop all containers (data remains in volumes)
docker-compose stop
```

**Result**:
- ✅ Containers stopped
- ✅ Data preserved in volumes
- ✅ Can restart anytime: `docker-compose start`

---

## 🗑️ Option 2: Full Cleanup (Remove Everything)

Use this if you want to completely remove all containers and volumes but keep images.

```bash
# Remove all containers and volumes
docker-compose down -v
```

**Result**:
- ✅ Containers removed
- ✅ Volumes deleted
- ✅ Networks removed
- ❌ Data in volumes is LOST
- ✅ Images still exist (for rebuilding)
- ✅ Workspace files still exist locally

**Time**: ~1 minute

---

## 🧼 Option 3: Complete Removal (Remove Everything Including Images)

Use this if you want to completely clean up everything.

```bash
# Step 1: Remove containers and volumes
docker-compose down -v

# Step 2: Remove custom image
docker rmi local/hadoop-namenode-sqoop:2.7.4

# Step 3 (Optional): Remove all Docker images
docker image prune -a -f
```

**Result**:
- ✅ Containers removed
- ✅ Volumes deleted
- ✅ Custom image removed
- ✅ All unused images removed
- ❌ Data LOST
- ✅ Workspace files still exist locally

**Time**: ~2-3 minutes

---

## 📊 Cleanup Comparison

| Option | Containers | Volumes | Images | Data | Time |
|--------|-----------|---------|--------|------|------|
| **Stop** | Stopped | Kept | Kept | ✅ Safe | 1 min |
| **down -v** | Removed | Removed | Kept | ❌ Lost | 1 min |
| **Full Clean** | Removed | Removed | Removed | ❌ Lost | 2 min |

---

## 🔄 Step-by-Step Cleanup Procedures

### Procedure 1: Temporary Pause (Stop)

**Use when**: You'll use the lab again soon

```bash
# Stop everything
docker-compose stop

# To restart later
docker-compose start
```

### Procedure 2: Complete Shutdown (Down + Volumes)

**Use when**: You don't need the lab for a while

```bash
# First, backup workspace if you have important files
cp -r workspace workspace-backup

# Remove everything
docker-compose down -v

# To use again later
docker-compose up -d
```

### Procedure 3: Full System Clean (Remove Images Too)

**Use when**: You want to free up maximum disk space

```bash
# Step 1: Backup workspace
cp -r workspace workspace-backup

# Step 2: Stop and remove containers
docker-compose down -v

# Step 3: Remove custom image
docker rmi local/hadoop-namenode-sqoop:2.7.4

# Step 4: (Optional) Remove base images
docker image prune -a -f

# Step 5: To use again, rebuild from scratch
docker build -t local/hadoop-namenode-sqoop:2.7.4 .
docker-compose up -d
```

---

## 💾 Backup Workspace Before Cleanup

### Quick Backup

```bash
# Copy workspace to backup folder
cp -r workspace workspace-backup-$(date +%Y%m%d)

# List your backups
ls -la | grep workspace-backup
```

### Compress Backup

```bash
# Create compressed archive
tar -czf workspace-backup-$(date +%Y%m%d).tar.gz workspace/

# Or on Windows
# Use 7-Zip or built-in compression
```

### Save Important Results

```bash
# Save outputs
cp -r workspace/outputs outputs-backup

# Save scripts
cp -r workspace/pig_scripts scripts-backup
```

---

## 🧻 Cleanup Commands Quick Reference

### Stop Everything
```bash
docker-compose stop
```

### Start Again
```bash
docker-compose start
```

### Full Shutdown (Remove Containers & Volumes)
```bash
docker-compose down -v
```

### Remove Custom Image
```bash
docker rmi local/hadoop-namenode-sqoop:2.7.4
```

### Remove All Containers
```bash
docker rm $(docker ps -aq)
```

### Remove All Volumes
```bash
docker volume prune -f
```

### Remove All Unused Images
```bash
docker image prune -a -f
```

### Complete System Clean
```bash
docker system prune -a -f --volumes
```

---

## 📊 Disk Space Cleanup

### Check Disk Usage

```bash
# See what's taking space
docker system df

# Result shows:
# - Images size
# - Containers size
# - Volumes size
```

### Free Up Space

```bash
# Remove unused containers, images, volumes
docker system prune -a -f --volumes

# This frees up:
# ✅ Stopped containers
# ✅ Unused images
# ✅ Unused volumes
# ✅ Dangling objects
```

**Space freed**: Usually 5-10 GB

---

## 🔄 Restart After Cleanup

### If You Used `docker-compose stop`

```bash
# Simply start again
docker-compose start

# Containers come back online immediately
docker-compose ps
```

### If You Used `docker-compose down -v`

```bash
# Restart the lab
docker-compose up -d

# Services recreate from existing images
docker-compose ps
```

### If You Removed Images Too

```bash
# Rebuild everything from scratch
docker build -t local/hadoop-namenode-sqoop:2.7.4 .

# Start services
docker-compose up -d

# Lab is ready again
docker-compose ps
```

---

## ⚠️ Important Notes

### Data Loss Warning
```bash
# ❌ These commands DELETE data in volumes
docker-compose down -v
docker volume prune
docker system prune -a --volumes

# ✅ Backup first!
cp -r workspace workspace-backup
```

### What's NOT Deleted

These remain even after full cleanup:
- ✅ `workspace/` directory (local files)
- ✅ `.gitignore` files
- ✅ Configuration files
- ✅ Docker installation

### What IS Deleted

These are removed:
- ❌ Running containers
- ❌ Docker volumes (data)
- ❌ Docker images (if you remove them)
- ❌ Networks

---

## 🎯 Recommended Cleanup Strategy

### Daily Use
```bash
# When done for the day
docker-compose stop

# Tomorrow
docker-compose start
```

### End of Week
```bash
# Backup important results
cp -r workspace/outputs outputs-week-$(date +%w)

# Clean up
docker-compose down -v

# Rebuild if needed
docker-compose up -d
```

### End of Project
```bash
# Final backup
tar -czf workspace-final-backup.tar.gz workspace/

# Save to cloud/drive
# Then full cleanup
docker system prune -a -f --volumes
```

---

## 🔧 Troubleshooting Cleanup

### Containers Won't Stop
```bash
# Force stop
docker-compose kill

# Then remove
docker-compose down -v
```

### Permission Denied
```bash
# On Linux/Mac, might need sudo
sudo docker-compose down -v
```

### Docker Daemon Issues
```bash
# Restart Docker
# Linux: sudo systemctl restart docker
# Mac: Docker Desktop → restart
# Windows: Docker Desktop → restart

# Then try cleanup again
docker-compose down -v
```

### Volume Still in Use
```bash
# Find which container uses volume
docker ps -a

# Stop that container
docker stop container_name

# Then remove volume
docker volume prune -f
```

---

## 📋 Cleanup Checklist

Before removing everything:

- [ ] Backup workspace directory
- [ ] Save important results
- [ ] Copy scripts and code
- [ ] Export any database data if needed
- [ ] Verify backups are complete
- [ ] Ready to proceed with cleanup

---

## ✅ After Cleanup

### Verify Everything is Clean

```bash
# Check containers
docker ps -a          # Should be empty

# Check volumes
docker volume ls      # Should show minimal volumes

# Check images
docker images         # Should show remaining images

# Check disk usage
docker system df      # Should show reduced usage
```

### Verify Files Remain

```bash
# Your local files are safe
ls workspace/

# Configuration files remain
ls README.md docker-compose.yml Dockerfile
```

---

## 🎯 Quick Decision Guide

**I'm just pausing for today:**
→ `docker-compose stop`

**I'm done for now, want to clean up:**
→ `docker-compose down -v`

**I want to free up disk space:**
→ `docker system prune -a -f --volumes`

**I want to start completely fresh:**
→ Remove everything and rebuild

---

## 📞 Need Help?

- **Containers won't stop?** → Use `docker-compose kill`
- **Volumes won't delete?** → Make sure all containers stopped
- **Out of disk space?** → Use `docker system df` to check
- **Want to recover data?** → Restore from workspace-backup

---

## 🚀 Ready to Use Again?

After cleanup, restart is simple:

```bash
# If containers exist
docker-compose start

# If everything removed
docker-compose up -d

# Verify
docker-compose ps

# Your lab is ready! 🎉
```

---

**Cleanup is simple and safe!** Always backup first. 🛡️

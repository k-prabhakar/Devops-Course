# Jenkins-to-S3 backup script using Git, and optionally integrate it into a CI/CD workflow
# Connects to Jenkins (via SSH or by accessing the Jenkins home directory if local).
# Archives the Jenkins job configurations (XML files in $JENKINS_HOME/jobs/).
# Uploads the backup archive to a specified AWS S3 bucket.

# Prerequisites

# Jenkins server accessible (locally or via SSH).
# AWS CLI installed and configured (aws configure).
# IAM role or access key with S3 PutObject permissions.
# S3 bucket already created (e.g., jenkins-job-backups).

#!/bin/bash

# === CONFIGURATION ===
JENKINS_HOST="jenkins@your-jenkins-server.com"  # SSH access
JENKINS_HOME="/var/lib/jenkins"                # Jenkins home directory
BACKUP_DIR="/tmp/jenkins_backup_$(date +%F_%H-%M-%S)"
S3_BUCKET="s3://jenkins-job-backups"
ARCHIVE_NAME="jenkins_jobs_backup_$(date +%F_%H-%M-%S).tar.gz"

# === STEP 1: Create backup directory ===
mkdir -p "$BACKUP_DIR"

# === STEP 2: Copy Jenkins job configs from server ===
echo "Copying job configurations from Jenkins..."
scp -r "${JENKINS_HOST}:${JENKINS_HOME}/jobs" "$BACKUP_DIR"

# === STEP 3: Archive the backup ===
echo "Creating archive..."
tar -czf "/tmp/$ARCHIVE_NAME" -C "$BACKUP_DIR" jobs

# === STEP 4: Upload to S3 ===
echo "Uploading backup to S3..."
aws s3 cp "/tmp/$ARCHIVE_NAME" "$S3_BUCKET"

# === STEP 5: Cleanup ===
echo "Cleaning up..."
rm -rf "$BACKUP_DIR"
rm -f "/tmp/$ARCHIVE_NAME"

echo "✅ Jenkins job backup completed and uploaded to S3."

#!/bin/bash

# Path to Jenkins home
JENKINS_HOME="/var/lib/jenkins"
# S3 bucket name
S3_BUCKET="s3://your-s3-bucket-name/jenkins-backup"
# Current timestamp
TIMESTAMP=$(date +%F_%H-%M-%S)
# Backup directory
BACKUP_DIR="/tmp/jenkins-backup-$TIMESTAMP"
# Backup file
BACKUP_FILE="/tmp/jenkins-backup-$TIMESTAMP.tar.gz"

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Copy Jenkins data
cp -r "$JENKINS_HOME" "$BACKUP_DIR"

# Compress the backup
tar -czf "$BACKUP_FILE" -C /tmp "jenkins-backup-$TIMESTAMP"

# Upload to S3
aws s3 cp "$BACKUP_FILE" "$S3_BUCKET/jenkins-backup-$TIMESTAMP.tar.gz"

# Cleanup
rm -rf "$BACKUP_DIR" "$BACKUP_FILE"

echo "Backup completed and uploaded to S3 at $TIMESTAMP"


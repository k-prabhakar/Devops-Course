#!/bin/bash

# Variables
JENKINS_HOME="/var/lib/jenkins"
S3_BUCKET="s3://technova-jenkins-backups"
TIMESTAMP=$(date +'%Y-%m-%d_%H-%M-%S')
BACKUP_NAME="jenkins-backup-$TIMESTAMP.tar.gz"

# Create a compressed backup of JENKINS_HOME
tar -czf /tmp/$BACKUP_NAME -C $JENKINS_HOME .

# Upload backup to S3
aws s3 cp /tmp/$BACKUP_NAME $S3_BUCKET/$BACKUP_NAME

# Remove local backup to save space
rm /tmp/$BACKUP_NAME

echo "Jenkins backup completed: $BACKUP_NAME"

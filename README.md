# Rclone-Restic Backup and Restore Docker Image

## Purpose

This Docker image provides a simple and secure way to backup and restore data using rclone and restic. It's designed to work with various cloud storage providers supported by rclone, with a focus on WebDAV storage.

## Prerequisites

Before using this image, you need to:

1. Prepare your rclone configuration file.
2. Base64 encode your rclone configuration:
   ```
   base64 -w 0 rclone.conf > rclone_config_base64.txt
   ```

## Restoring Data

To restore data from a backup:

1. Run the Docker container in restore mode:
   ```
   docker run --rm \
     -e RCLONE_CONFIG_BASE64=$(cat rclone_config_base64.txt) \
     -e RCLONE_BACKUP_PATH="myremote:/path/to/backup" \
     -e RESTIC_PASSWORD="your_restic_password" \
     -v ./local_restore_dir:/restore \
     rclone-restic-image ./restore.sh
   ```

   Replace `myremote:/path/to/backup` with your actual remote path, `your_restic_password` with your restic repository password, and `./local_restore_dir` with the local directory where you want to restore the files.

## Backing Up Data

To use this image for backing up data to restic:

1. Run the Docker container in backup mode:
   ```
   docker run --rm \
     -e RCLONE_CONFIG_BASE64=$(cat rclone_config_base64.txt) \
     -e RCLONE_BACKUP_PATH="myremote:/path/to/backup" \
     -e RESTIC_PASSWORD="your_restic_password" \
     -v /path/to/data:/data \
     rclone-restic-image ./backup.sh
   ```

   Replace `myremote:/path/to/backup` with your desired remote backup path, `your_restic_password` with your restic repository password, and `/path/to/data` with the local path of the data you want to backup.

## Environment Variables

- `RCLONE_CONFIG_BASE64`: Base64 encoded rclone configuration (required)
- `RCLONE_BACKUP_PATH`: The remote path for your backup (default: "123rw:/rc-backup")
- `RESTIC_PASSWORD`: The password for your restic repository (required for both backup and restore operations)

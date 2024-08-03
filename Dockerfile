# Use a base image with rclone and restic
FROM alpine:latest

# Install required packages
RUN apk add --no-cache rclone restic bash

# Set up the scripts
COPY backup.sh /backup.sh
COPY restore.sh /restore.sh
RUN chmod +x /backup.sh /restore.sh

# Set the entrypoint
ENTRYPOINT ["/bin/bash", "-c"]
CMD ["echo", "Specify a command: './backup.sh' or './restore.sh'"]

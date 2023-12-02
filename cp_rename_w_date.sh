#!/bin/bash

# Set the source and destination directories
source_dir=""
destination_dir="/filtered_files"
# Filter file size greater than KB
file_size=512000

# Check if destination directory exists; if yes, quit the script
if [ -d "$destination_dir" ]; then
    echo "Destination directory already exists: $destination_dir"
    echo "Script will exit."
    exit 0
fi

# Create the destination directory
mkdir -p "$destination_dir"
echo "Destination directory created: $destination_dir"

# Loop through all recup_dir.* directories
for dir in "$source_dir"/recup_dir.*; do
    # Loop through files in each recup_dir directory
    for file in "$dir"/*; do
        # Check if file exists and its size is greater than 500KB
        if [ -f "$file" ] && [ $(stat -f%z "$file") -gt "$file_size" ]; then
            # Get file creation date
            created_date=$(stat -f%SB -t "%Y%m%d_%H%M%S" "$file")
            # Get file extension
            extension="${file##*.}"
            # Construct new file name with date and extension
            new_name="${destination_dir}/${created_date}.${extension}"
            # Echo the file being copied
            echo "Copying: $file to $new_name"
            # Copy the file to the destination with the new name
            cp -p "$file" "$new_name"
        fi
    done
done


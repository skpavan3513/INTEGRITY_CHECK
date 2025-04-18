#!/bin/bash

# Function to generate and save the checksum
generate_checksum() {
    local file_path=$1
    local checksum_file=$2

    # Generate the checksum and save it to the checksum file
    md5sum "$file_path" > "$checksum_file"
    echo "Checksum generated and saved to $checksum_file."
}

# Function to verify the file's integrity
verify_checksum() {
    local file_path=$1
    local checksum_file=$2

    # Generate a new checksum and compare it with the stored one
    md5sum -c "$checksum_file"

    # Check if the verification was successful
    if [ $? -eq 0 ]; then
        echo "Integrity check passed. The file has not been altered."
    else
        echo "Integrity check failed. The file has been altered."
    fi
}

# Prompt the user to choose an operation
echo "Please choose an option:"
echo "1. Generate checksum"
echo "2. Verify checksum"
read -p "Enter your choice (1/2): " choice

if [[ $choice == "1" ]]; then
    # Read the file path from the user
    read -p "Enter the path to the file you want to generate the checksum for: " file_path

    # Check if the file exists
    if [[ ! -f "$file_path" ]]; then
        echo "File not found: $file_path"
        exit 1
    fi

    # Set the checksum file name
    checksum_file="${file_path}.md5"

    # Generate the checksum
    generate_checksum "$file_path" "$checksum_file"

elif [[ $choice == "2" ]]; then
    # Read the file path from the user
    read -p "Enter the path to the file you want to verify: " file_path

    # Set the checksum file name
    checksum_file="${file_path}.md5"

    # Check if the checksum file exists
    if [[ ! -f "$checksum_file" ]]; then
        echo "Checksum file not found: $checksum_file"
        exit 1
    fi

    # Verify the checksum
    verify_checksum "$file_path" "$checksum_file"
else
    echo "Invalid choice. Please enter '1' to generate or '2' to verify the checksum."
    exit 1
fi

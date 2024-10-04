#!/bin/bash

# Check if the path to the root directory is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 path_to_root_directory"
    exit 1
fi

# Store the root directory path
ROOT_DIR="$1"

# Find all Git repositories within the root directory
find "$ROOT_DIR" -type d -name ".git" | while read -r git_dir; do
    # Get the repository's working directory
    REPO_DIR="$(dirname "$git_dir")"
    echo "Processing repository: $REPO_DIR"

    # Change to the repository directory
    cd "$REPO_DIR" || { echo "Cannot change directory to $REPO_DIR"; continue; }

    # Ensure we are in a Git repository
    if [ ! -d ".git" ]; then
        echo "Not a Git repository: $REPO_DIR"
        continue
    fi

    # Restore file permissions to match the Git index
    git ls-files -s | while read -r mode _ _ file; do
        # Extract the permission bits (first 6 digits are mode)
        perm="${mode:0:6}"
        # Convert Git mode to filesystem permissions
        perm=$(echo "ibase=8; $perm" | bc)
        # Apply the permissions to the file
        chmod "$perm" "$file"
    done
done
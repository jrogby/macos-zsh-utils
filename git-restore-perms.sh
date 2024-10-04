#!/bin/bash

# Check if the path to the Git repository is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 path_to_git_repo"
    exit 1
fi

# Change to the specified directory
cd "$1" || { echo "Cannot change directory to $1"; exit 1; }

# Ensure we are in a Git repository
if [ ! -d ".git" ]; then
    echo "The specified directory is not a Git repository."
    exit 1
fi

# Restore file permissions
git ls-files -s | while read -r mode hash stage file; do
    # Extract the permission bits (remove the leading '100')
    perm=$(echo "$mode" | sed 's/^100//')
    # Ensure the permission is interpreted as octal
    chmod "0$perm" "$file"
done

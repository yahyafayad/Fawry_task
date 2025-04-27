#!/bin/bash

# Function to show usage
usage() {
    echo "Usage: $0 [-n] [-v] search_string filename"
    exit 1
}

# Check if no arguments are provided
if [ $# -lt 2 ]; then
    usage
fi

# Initialize options
show_line_numbers=false
invert_match=false

# Parse options manually
while [[ "$1" == -* ]]; do
    case "$1" in
        -n) show_line_numbers=true ;;
        -v) invert_match=true ;;
        -vn|-nv)
            show_line_numbers=true
            invert_match=true
            ;;
        --help)
            usage
            ;;
        *)
            echo "Invalid option: $1"
            usage
            ;;
    esac
    shift
done

# Now we should have search string and filename
if [ $# -lt 2 ]; then
    echo "Error: Missing search string or filename."
    usage
fi

search_string="$1"
file="$2"

# Validate file
if [ ! -f "$file" ]; then
    echo "Error: File '$file' not found."
    exit 1
fi

# Read the file line by line
line_number=0
while IFS= read -r line; do
    line_number=$((line_number + 1))
    
    if echo "$line" | grep -iq -- "$search_string"; then
        match=true
    else
        match=false
    fi

    if [ "$invert_match" = true ]; then
        match=$([ "$match" = false ] && echo true || echo false)
    fi

    if [ "$match" = true ]; then
        if [ "$show_line_numbers" = true ]; then
            printf "%d:%s\n" "$line_number" "$line"
        else
            echo "$line"
        fi
    fi
done < "$file"


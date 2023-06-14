#!/bin/bash

path="transcripts"
output_path="transcripts_md"

mkdir -p "$output_path"

find "$path" -type f -name "*.txt" | while IFS= read -r filepath; do
    if [[ "$filepath" != *"transcripts_full"* ]]; then
        filename=$(basename "$filepath")
        directory=$(dirname "$filepath")
        relative_dir=${directory#"$path"}

        content=$(<"$filepath")

        # Remove lines with only ":"
        content=$(echo "$content" | awk '!/^\s*:\s*$/')

        # Replace empty lines with a line break
        content=$(echo "$content" | awk '{if (NF==0) {print "\n***\n"} else {print}}')

        # Format dialogue lines with a new line after the character name
        content=$(echo "$content" | sed -E "s/^:+\s*//; s/([^:]+):\s*(.*)/\n\n**\1**:\n\2/")

        # Format character names by adding a colon and space
        content=$(echo "$content" | sed -E "s/([^:\n]+):/\\1:  /")

        output_directory="$output_path$relative_dir"
        mkdir -p "$output_directory"

        output_file="$output_directory/${filename%.txt}.md"
        echo "$content" > "$output_file"

        echo "Converted '$filename' to '$output_file'"
    fi
done

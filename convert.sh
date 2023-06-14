#!/bin/bash

path="transcripts"
output_path="transcripts_md"

rm -rf "${output_path:?}"/*

mkdir -p "$output_path"

find "$path" -type f -name "*.txt" | while IFS= read -r filepath; do
    if [[ "$filepath" != *"transcripts_full"* ]]; then
        filename=$(basename "$filepath")
        directory=$(dirname "$filepath")
        relative_dir=${directory#"$path"}

        content=$(<"$filepath")
        content=$(awk '{if (NF==0) {print "\n***\n"} else {print}}' <<< "$content")
        content=$(sed -E "s/^:+\s*//; s/([^:]+):\s*(.*)/\n\n**\1**:\n\2/" <<< "$content")
        content=$(sed -E "s/([^:\n]+):/\\1:  /" <<< "$content")
        content=$(sed "s/'''//g" <<< "$content")
        content=$(sed "s/''/*/g" <<< "$content")
        content=$(sed '/^$/N;/^\n$/D' <<< "$content")

        output_directory="$output_path$relative_dir"
        mkdir -p "$output_directory"

        output_file="$output_directory/${filename%.txt}.md"
        echo "$content" > "$output_file"

        echo "Converted '$filename' to '$output_file'"
    fi
done

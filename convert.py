import os
import re

path = "transcripts"
output_path = "transcripts_md"

os.makedirs(output_path, exist_ok=True)

for root, _, filenames in os.walk(path):
    for filename in filenames:
        if filename.endswith(".txt") and "transcripts_full" not in root:
            with open(os.path.join(root, filename), "r") as file:
                file_content = file.read()

            file_content = re.sub(r":\[([^\]]+)\]", r"\n\n\1:\n\n", file_content)
            file_content = re.sub(r"'''([^']+?)'''", r"\n\1:\n", file_content)
            file_content = re.sub(r"\[offscreen: ([^\]]+)\]", r"(\1)", file_content)
            file_content = re.sub(r"\n{2,}", "\n", file_content.strip())
            file_content = re.sub(r"(?<=\n)\n(?=\n)", r"\n***\n", file_content)
            file_content = re.sub(r"\n([^:\n]+):([^\n\S])", r"\n\1\2", file_content)

            output_file_path = os.path.join(output_path, os.path.relpath(root, path), filename[:-4] + ".md")
            os.makedirs(os.path.dirname(output_file_path), exist_ok=True)

            with open(output_file_path, "w") as output_file:
                output_file.write(file_content)

            print(f"Converted '{filename}' to '{output_file_path}'")

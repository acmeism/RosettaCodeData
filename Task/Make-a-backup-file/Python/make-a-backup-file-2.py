from pathlib import Path

filepath = Path("original_file")
filepath.rename(filepath.with_suffix('.bak'))
with filepath.open('w') as file:
    file.write("New content")

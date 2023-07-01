from pathlib import Path

for path in Path('.').rglob('*.*'):
    print(path)

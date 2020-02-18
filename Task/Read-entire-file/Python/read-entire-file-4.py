from pathlib import Path

any_string = Path(filename).read_text(encoding='utf-8')
any_binary_data = Path(filename).read_bytes()

import csv
from pathlib import Path
from tempfile import NamedTemporaryFile

filepath = Path('data.csv')
temp_file = NamedTemporaryFile('w',
                               newline='',
                               delete=False)

with filepath.open() as csv_file, temp_file:
    reader = csv.reader(csv_file)
    writer = csv.writer(temp_file)

    header = next(reader)
    writer.writerow(header + ['SUM'])

    for row in reader:
        row_sum = sum(map(int, row))
        writer.writerow(row + [row_sum])

temp_file_path = Path(temp_file.name)
temp_file_path.replace(filepath)

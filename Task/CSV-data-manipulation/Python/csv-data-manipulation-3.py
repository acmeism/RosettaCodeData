import pandas as pd

filepath = 'data.csv'

df = pd.read_csv(filepath)
rows_sums = df.sum(axis=1)
df['SUM'] = rows_sums
df.to_csv(filepath, index=False)

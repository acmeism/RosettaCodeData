import polars as pl

filepath = "data.csv"

(
    pl.scan_csv(filepath)
    .with_columns(pl.sum_horizontal(pl.all()).alias("SUM"))
    .sink_csv(filepath)
)

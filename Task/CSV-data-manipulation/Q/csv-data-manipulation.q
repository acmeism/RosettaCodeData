t:("IIIII";enlist ",")0: `:input.csv    / Read CSV file input.csv into table t
t:update SUM:sum value flip t from t    / Add SUM column to t
`:output.csv 0: csv 0: t                / Write updated table as CSV to output.csv

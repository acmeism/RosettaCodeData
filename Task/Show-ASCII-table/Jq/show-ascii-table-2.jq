# produce a flat array
def prepare($m;$n):
  [range($m; $n) | "\(lpad(7)): \(humanize)" ];

# Row-wise presentation of 32 through 127 in 6 columns
prepare(32;128) | table(6; 10)

# Column-wise with 16 rows would be produced by:
# prepare(32;128) | ttable(16)

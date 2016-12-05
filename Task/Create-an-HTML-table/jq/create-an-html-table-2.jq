def data:
  [ [4,5,6],
    [41, 51, 61],
    [401, 501, 601] ];

# The first column has no header
data | html_table_with_sequence( ["", "X", "Y", "Z"] )

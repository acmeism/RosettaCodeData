# Create an array of arrays by using the items in the stream, s,
# to create successive rows, each row having at most n items.
def reshape(s; n):
  reduce s as $s ({i:0, j:0, matrix: []};
    .matrix[.i][.j] = $s
    | if .j + 1 == n then .i += 1 | .j = 0
      else .j += 1
      end)
  | .matrix;

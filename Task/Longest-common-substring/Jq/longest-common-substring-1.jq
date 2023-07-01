# Create an m x n matrix
def matrix(m; n; init):
  if m == 0 then []
  elif m == 1 then [range(0;n) | init]
  elif m > 0 then
    matrix(1;n;init) as $row
    | [range(0;m) | $row ]
  else error("matrix\(m);_;_) invalid")
  end;

def set(i;j; value):
  setpath([i,j]; value);

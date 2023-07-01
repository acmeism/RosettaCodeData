def sudan(n;x;y):
  if   n == 0 then x+y
  elif y == 0 then x
  else sudan(n-1; sudan(n;x;y-1); sudan(n;x;y-1) + y)
  end;

# For testing and syntactic convenience:
def sudan:
  "sudan(\(.[0]); \(.[1]); \(.[2])) => \(sudan(.[0]; .[1]; .[2]))";

# Illustrations
[0,0,0], [1,1,1], [2,1,1], [3,1,1], [2,2,1]
| sudan

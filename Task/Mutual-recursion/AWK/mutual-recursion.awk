cat mutual_recursion.awk:
#!/usr/local/bin/gawk -f

# User defined functions
function F(n)
{ return n == 0 ? 1 : n - M(F(n-1)) }

function M(n)
{ return n == 0 ? 0 : n - F(M(n-1)) }

BEGIN {
  for(i=0; i <= 20; i++) {
    printf "%3d ", F(i)
  }
  print ""
  for(i=0; i <= 20; i++) {
    printf "%3d ", M(i)
  }
  print ""
}

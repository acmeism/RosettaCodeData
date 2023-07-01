f := function(n)
  return f(n+1);
end;

# Now loop until an error occurs
f(0);

# Error message :
#   Entering break read-eval-print loop ...
#   you can 'quit;' to quit to outer loop, or
#   you may 'return;' to continue

n;
# 4998

# quit "brk mode" and return to GAP
quit;

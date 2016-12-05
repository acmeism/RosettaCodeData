# Single-string version using explicit nested loops:
def demo(m):
  reduce range(0;m) as $i
    (""; reduce range(0;$i) as $j
           (.; . + "*" )  + "\n" ) ;

# Stream of strings:
def demo2(m):
  range(1;m)
  | reduce range(0;.) as $j (""; . + "*");

# Variation of demo2 using an implicit inner loop:
def demo3(m): range(1;m) | "*" * . ;

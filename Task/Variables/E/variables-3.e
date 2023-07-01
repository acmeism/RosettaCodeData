def var x := 1
x += 1                # equivalent to x := x + 1, or x := x.add(1)
x                     # returns 2

def var list := ["x"]
list with= "y"        # equivalent to list := list.with("y")
list                  # returns ["x", "y"]

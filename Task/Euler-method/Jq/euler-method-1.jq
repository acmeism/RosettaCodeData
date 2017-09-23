# euler_method takes a filter (df), initial condition
# (x1,y1), ending x (x2), and step size as parameters;
# it emits the y values at each iteration.
# df must take [x,y] as its input.
def euler_method(df; x1; y1; x2; h):
  h as $h
  | [x1, y1]
  | recurse( if ((.[0] < x2 and x1 < x2) or
                 (.[0] > x2 and x1 > x2)) then
  		[ (.[0] + $h), (.[1] + $h*df) ]
             else empty
             end )
  | .[1] ;


# We could now solve the task by writing for each step-size, $h
# euler_method(-0.07 * (.[1]-20); 0; 100; 100; $h)
# but for clarity, we shall define a function named "cooling":

# [x,y] is input
def cooling: -0.07 * (.[1]-20);

# The following solves the task:
# (2,5,10) | [., [ euler_method(cooling; 0; 100; 100; .) ] ]

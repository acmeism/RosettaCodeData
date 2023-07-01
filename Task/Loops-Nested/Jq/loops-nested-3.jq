# Create an m x n matrix filled with numbers in [1 .. max]
def randomMatrix(m; n; max):
  reshape(limit(m * n; rand(max) + 1); n);

# Present the matrix up to but excluding the first occurrence of $max
def show($m; $n; $max):
  reshape( randomMatrix($m; $n; $max) | stream($max); $n)[] ;

# Main program for the problem at hand.
show(20; 4; 20)

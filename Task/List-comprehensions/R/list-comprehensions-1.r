x = (0:10)
> x^2
 [1]   0   1   4   9  16  25  36  49  64  81 100
> Reduce(function(y,z){return (y+z)},x)
[1] 55
> x[x[(0:length(x))] %% 2==0]
[1]  0  2  4  6  8 10

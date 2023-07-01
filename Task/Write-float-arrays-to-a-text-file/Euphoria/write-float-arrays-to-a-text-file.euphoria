constant x = {1, 2, 3, 1e11},
         y = {1, 1.4142135623730951, 1.7320508075688772, 316227.76601683791}

integer fn

fn = open("filename","w")
for n = 1 to length(x) do
    printf(fn,"%.3g\t%.5g\n",{x[n],y[n]})
end for
close(fn)

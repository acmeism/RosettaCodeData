# v0.6
using IterTools

str = "gHHH5YY++///\\"
sep = map(join, groupby(identity, str))
println("string: $str\nseparated: ", join(sep, ", "))

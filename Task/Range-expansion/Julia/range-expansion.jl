slurp(s) = readcsv(IOBuffer(s))

conv(s)= colon(map(x->parse(Int,x),match(r"^(-?\d+)-(-?\d+)$", s).captures)...)

expand(s) = mapreduce(x -> isa(x,Number)? Int(x) : conv(x), vcat, slurp(s))

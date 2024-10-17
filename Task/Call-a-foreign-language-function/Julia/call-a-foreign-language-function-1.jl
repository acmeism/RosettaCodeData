p = ccall(:strdup, Ptr{Cuchar}, (Ptr{Cuchar},), "Hello world")
@show unsafe_string(p) # "Hello world"
ccall(:free, Void, (Ptr{Cuchar},), p)

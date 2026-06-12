julia> unsafe_load(convert(Ptr{Int}, C_NULL))

Exception: EXCEPTION_ACCESS_VIOLATION at 0x511008e4 -- unsafe_load at .\pointer.jl:105 [inlined]
unsafe_load at .\pointer.jl:105
...

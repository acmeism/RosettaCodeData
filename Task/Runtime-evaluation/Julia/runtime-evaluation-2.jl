include_string("""
    x = sum([1, 2, 3])
    @show x
    """)

@show typeof(x) # Int64

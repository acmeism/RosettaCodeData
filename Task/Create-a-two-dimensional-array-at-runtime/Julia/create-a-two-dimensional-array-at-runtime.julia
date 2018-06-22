function input(prompt::AbstractString)
    print(prompt)
    return readline()
end

n = input("Upper bound for dimension 1: ") |>
    x -> parse(Int, x)
m = input("Upper bound for dimension 2: ") |>
    x -> parse(Int, x)

x = rand(n, m)
display(x)
x[3, 3]         # overloads `getindex` generic function
x[3, 3] = 5.0   # overloads `setindex!` generic function
x::Matrix # `Matrix{T}` is an alias for `Array{T, 2}`
x = 0; gc() # Julia has no `del` command, rebind `x` and call the garbage collector

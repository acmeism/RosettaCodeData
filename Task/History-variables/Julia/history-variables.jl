mutable struct Historied
    num::Number
    history::Vector{Number}
    Historied(n) = new(n, Vector{Number}())
end

assign(y::Historied, z) = (push!(y.history, y.num); y.num = z; y)

x = Historied(1)

assign(x, 3)
assign(x, 5)
assign(x, 4)

println("Past history of variable x: $(x.history). Current value is $(x.num)")

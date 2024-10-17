abstract type Mammal end
habitat(::Mammal) = "planet Earth"

struct Whale <: Mammal
    mass::Float64
    habitat::String
end
Base.show(io::IO, ::Whale) = print(io, "a whale")
habitat(w::Whale) = w.habitat

struct Wolf <: Mammal
    mass::Float64
end
Base.show(io::IO, ::Wolf) = print(io, "a wolf")

arr = [Whale(1000, "ocean"), Wolf(50)]
println("Type of $arr is ", typeof(arr))
for a in arr
    println("Habitat of $a: ", habitat(a))
end

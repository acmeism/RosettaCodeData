abstract type Edible end
eat(::Edible) = "Yum!"

mutable struct FoodBox{T<:Edible}
    food::Vector{T}
end

struct Carrot <: Edible
    variety::AbstractString
end

struct Brick
    volume::Float64
end

c = Carrot("Baby")
b = Brick(125.0)
eat(c)
eat(b)

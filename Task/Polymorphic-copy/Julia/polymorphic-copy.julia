abstract type Jewel end

mutable struct RoseQuartz <: Jewel
    carats::Float64
    quality::String
end

mutable struct Sapphire <: Jewel
    color::String
    carats::Float64
    quality::String
end

color(j::RoseQuartz) = "rosepink"
color(j::Jewel) = "Use the loupe."
color(j::Sapphire) = j.color

function testtypecopy()
    a = Sapphire("blue", 5.0, "good")
    b = RoseQuartz(3.5, "excellent")

    j::Jewel = deepcopy(b)

    println("a is a Jewel? ", a isa Jewel)
    println("b is a Jewel? ", a isa Jewel)
    println("j is a Jewel? ", a isa Jewel)
    println("a is a Sapphire? ", a isa Sapphire)
    println("a is a RoseQuartz? ", a isa RoseQuartz)
    println("b is a Sapphire? ", b isa Sapphire)
    println("b is a RoseQuartz? ", b isa RoseQuartz)
    println("j is a Sapphire? ", j isa Sapphire)
    println("j is a RoseQuartz? ", j isa RoseQuartz)

    println("The color of j is ", color(j), ".")
    println("j is the same as b? ", j == b)
end

testtypecopy()

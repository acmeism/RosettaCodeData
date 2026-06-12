""" Define datatypes and functions for a simple integer-like system in Julia. """

""" The natural number type is either 0 or the successor of another natural number. """
abstract type NaturalNumber end

""" Define a Zero type as a subtype of NaturalNumber. """
struct Zero <: NaturalNumber end

""" Define a Succ type as a NaturalNumber which holds either its prior or a String. """
struct Succ <: NaturalNumber
    val::Union{NaturalNumber, String}
end

""" Define abstract types for even and odd. """
abstract type Parity end
struct Even <: Parity end
struct Odd <: Parity end

# Global environment data storage, used for memoization
const environment = Dict{String, Any}()

""" printing a Zero """
Base.print(io::IO, ::Zero) = print(io, "Zero")

""" printing a Succ """
Base.print(io::IO, succ::Succ) = print(io, "Succ($(succ.val))")

""" printing Even and Odd Parity types """
Base.print(io::IO, ::Even) = print(io, "Even")
Base.print(io::IO, ::Odd) = print(io, "Odd")

""" parity Zero is defined to be Even """
parity(::Zero) = Even()

""" parity Succ is defined recursively based on the value it holds. """
function parity(succ::Succ)
    if succ.val isa Zero
        return Odd()
    elseif succ.val isa Succ
        if succ.val.val isa Zero
            return Even()
        end
        return parity(succ.val.val)
    else
        term = "parity $(string(succ))"
        if haskey(environment, term)
            return environment[term]
        elseif haskey(environment, string(succ))
            return parity(environment[string(succ)])
        else
            return term
        end
    end
end

""" parity for string types returns data entry or just as string """
function parity(val::AbstractString)
    term = "parity $val"
    if haskey(environment, term)
        return environment[term]
    elseif haskey(environment, val)
        return parity(environment[val])
    else
        return term
    end
end

""" add function for various combinations of Zero and Succ types """
function add(a::Zero, b::Zero)
    return Zero()
end
function add(a::Zero, b)
    return b
end
function add(a::Succ, b)
    Succ(add(a.val, b))
end
function add(a, b::Zero)
    return a
end
function add(a, b::Succ)
    Succ(add(a, b.val))
end
function add(a::Succ, b::Succ)
    Succ(add(a.val, b))
end

""" add function for other types gets its memoized entry or else as a string """
function add(a, b)
    term = "add $(string(a)) $(string(b))"
    if haskey(environment, term)
        return environment[term]
    elseif haskey(environment, string(a))
        return add(environment[string(a)], b)
    elseif haskey(environment, string(b))
        return add(a, environment[string(b)])
    else
        return term
    end
end

""" Test cases for the natural number-like system. """
function test_naturals_odd_even()
    println("Base case with natural number zero: ")
    println("parity Zero = $(parity(Zero()))")
    println("parity [add Zero Zero] = $(parity(add(Zero(), Zero())))")

    println("\nExample of an iterative case with successor natural numbers:")
    println("if parity p = Even...")
    environment["parity p"] = Even() # assumed
    println("\tparity [Succ [Succ p]] = $(parity(Succ(Succ("p"))))")

    # Clear environment of the prior assumption
    empty!(environment)

    println("if parity [add p q] = Even...")
    environment["parity add p q"] = Even() # new assumption

    # Test cases
    test_cases = [
        ("p", "q"),
        (Succ(Succ("p")), "q"),
        ("p", Succ(Succ("q"))),
        (Succ(Succ("p")), Succ(Succ("q"))),
    ]

    for (a, b) in test_cases
        println("\tparity [add $a $b] = $(parity(add(a, b)))")
    end
end

test_naturals_odd_even()

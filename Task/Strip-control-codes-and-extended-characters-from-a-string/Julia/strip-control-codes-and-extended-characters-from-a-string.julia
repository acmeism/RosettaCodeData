stripc0{T<:String}(a::T) = replace(a, r"[\x00-\x1f\x7f]", "")
stripc0x{T<:String}(a::T) = replace(a, r"[^\x20-\x7e]", "")

a = "a\n\tb\u2102d\u2147f"

println("Original String:\n    ", a)
println("\nWith C0 control characters removed:\n    ", stripc0(a))
println("\nWith C0 and extended characters removed:\n    ", stripc0x(a))

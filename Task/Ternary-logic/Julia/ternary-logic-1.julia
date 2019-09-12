@enum Trit False Maybe True
const trits = (False, Maybe, True)

Base.:!(a::Trit) = a == False ? True : a == Maybe ? Maybe : False
∧(a::Trit, b::Trit) = a == b == True ? True : (a, b) ∋ False ? False : Maybe
∨(a::Trit, b::Trit) = a == b == False ? False : (a, b) ∋ True ? True : Maybe
⊃(a::Trit, b::Trit) = a == False || b == True ? True : (a, b) ∋ Maybe ? Maybe : False
≡(a::Trit, b::Trit) = (a, b) ∋ Maybe ? Maybe : a == b ? True : False

println("Not (!):")
println(join(@sprintf("%10s%s is %5s", "!", t, !t) for t in trits))
println("And (∧):")
for a in trits
    println(join(@sprintf("%10s ∧ %5s is %5s", a, b, a ∧ b) for b in trits))
end
println("Or (∨):")
for a in trits
    println(join(@sprintf("%10s ∨ %5s is %5s", a, b, a ∨ b) for b in trits))
end
println("If Then (⊃):")
for a in trits
    println(join(@sprintf("%10s ⊃ %5s is %5s", a, b, a ⊃ b) for b in trits))
end
println("Equivalent (≡):")
for a in trits
    println(join(@sprintf("%10s ≡ %5s is %5s", a, b, a ≡ b) for b in trits))
end

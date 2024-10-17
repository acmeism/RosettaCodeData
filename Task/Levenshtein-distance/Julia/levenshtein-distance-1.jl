function levendist(s::AbstractString, t::AbstractString)
    ls, lt = length.((s, t))
    ls == 0 && return lt
    lt == 0 && return ls

    s₁, t₁ = s[2:end], t[2:end]
    ld₁ = levendist(s₁, t₁)
    s[1] == t[1] ? ld₁ : 1 + min(ld₁, levendist(s, t₁), levendist(s₁, t))
end

@show levendist("kitten", "sitting") # 3
@show levendist("rosettacode", "raisethysword") # 8

# Julia 1.0
function rot13(c::Char)
    shft = islowercase(c) ? 'a' : 'A'
    isletter(c) ? c = shft + (c - shft + 13) % 26 : c
end

rot13(str::AbstractString) = map(rot13, str)

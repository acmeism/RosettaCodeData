function passgen(len::Integer; simchars::Bool=true)::String
    if len < 4; error("length must be at least 4") end
    # Definitions
    DIGIT = collect('0':'9')
    UPPER = collect('A':'Z')
    LOWER = collect('a':'z')
    OTHER = collect("!\"#\$%&'()*+,-./:;<=>?@[]^_{|}~")
    if !simchars
        setdiff!(DIGIT, ['0', '1', '2', '5'])
        setdiff!(UPPER, ['O', 'I', 'Z', 'S'])
        setdiff!(LOWER, [     'l'])
    end
    ALL = union(DIGIT, UPPER, LOWER, OTHER)

    chars = collect(rand(set) for set in (DIGIT, UPPER, LOWER, OTHER))
    len -= 4
    append!(chars, rand(ALL, len))

    return join(shuffle!(chars))
end

function passgen(io::IO, len::Int=8, npass::Int=1; seed::Int=-1, simchars::Bool=true)::Vector{String}
    if seed > -1; srand(seed) end
    passwords = collect(passgen(len; simchars=simchars) for i in 1:npass)
    writedlm(io, passwords, '\n')
    return passwords
end

passgen(stdout, 10, 12; seed = 1)

# preprocess.jl convert includes to file contenets

infile = length(ARGS) > 0 ? ARGS[1] : stdin
outfile = length(ARGS) > 1 ? ARGS[2] : stdout

function includefile(s)
    try
        m = match(r"(\s)include\(\"([^\"]+)\"\)(\s)", s)
        return m.captures[1] * read(m.captures[2], String) * m.captures[3]
    catch y
        @warn y
        return s
    end
end

input = read(infile, String)
output = replace(input, r"\sinclude\(\"[^\"]+\"\)\s" => includefile)
write(outfile, output)

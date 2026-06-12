parseints() = (a = split(strip(readline()), r"\s+"); map(x -> parse(Int, x), a))

const lines = parseints()[1]

for _ in 1:lines
    println(sum(parseints()))
end

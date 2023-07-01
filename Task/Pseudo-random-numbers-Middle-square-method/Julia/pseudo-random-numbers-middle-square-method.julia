const seed = [675248]

function random()
    s = string(seed[] * seed[], pad=12) # turn a number into string, pad to 12 digits
    seed[] = parse(Int, s[begin+3:end-3]) # take middle of number string, parse to Int
    return seed[]
end

# Middle-square method use

for i = 1:5
    println(random())
end

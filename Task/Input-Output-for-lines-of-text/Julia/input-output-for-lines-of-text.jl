function dosomething(words)
    print(words)
end

nlines = parse.(Int, readline())
for _ in 1:nlines
    words = readline()
    dosomething(words)
end

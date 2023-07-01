d = .directory~new
d["hello"] = 1
d["world"] = 2
d["!"] = 3

-- iterating over keys:
loop key over d
    say "key =" key
end

-- iterating over values:
loop value over d~allitems
    say "value =" value
end

-- iterating over key-value pairs:
s = d~supplier
loop while s~available
    say "key =" s~index", value =" s~item
    s~next
end

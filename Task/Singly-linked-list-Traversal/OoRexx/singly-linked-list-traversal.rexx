say "Manual list traversal"
index = list~first           -- demonstrate traversal
loop while index \== .nil
    say index~value
    index = index~next
end

say
say "Do ... Over traversal"
do value over list
    say value
end

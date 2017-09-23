s = map~supplier
loop while s~available
    say s~index "=>" s~item
    s~next
end

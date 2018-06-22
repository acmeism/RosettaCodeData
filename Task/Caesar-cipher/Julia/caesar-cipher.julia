function rot(ch::Char, key::Integer)
    if key < 1 || key > 25 end
    if isalpha(ch)
        shft = ifelse(islower(ch), 'a', 'A')
        ch = (ch - shft + key) % 26 + shft
    end
    return ch
end
rot(str::AbstractString, key::Integer) = map(x -> rot(x, key), str)

msg = "The five boxing wizards jump quickly"
key = 3
invkey = 26 - 3

println("# original: $msg\n  encrypted: $(rot(msg, key))\n  decrypted: $(rot(rot(msg, key), invkey))")

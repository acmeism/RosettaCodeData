polybius(text) = Char.(reshape(Int.(collect(text)), isqrt(length(text)), :)')

function encrypt(message, poly)
    positions = [findall(==(c), poly)[1] for c in message]
    numbers = vcat([c[1] for c in positions], [c[2] for c in positions])
    return String([poly[numbers[i], numbers[i+1]] for i in 1:2:length(numbers)-1])
end

function decrypt(message, poly)
   n = length(message)
   positions = [findall(==(c), poly)[1] for c in message]
   numbers = reduce(vcat, [[c[1], c[2]] for c in positions])
   return String([poly[numbers[i], numbers[i+n]] for i in 1:n])
end


for (key, text) in [("ABCDEFGHIKLMNOPQRSTUVWXYZ", "ATTACKATDAWN"), ("BGWKZQPNDSIOAXEFCLUMTHYVR", "FLEEATONCE"),
   ([' '; '.'; 'A':'Z'; 'a':'z'; '0':'9'], "The invasion will start on the first of January 2023.")]
    poly = polybius(key)
    encrypted = encrypt(text, poly)
    decrypted = decrypt(encrypted, poly)
    println("Using polybius:")
    display(poly)
    println("\n  Message: $text\n    Encrypted: $encrypted\n    Decrypted: $decrypted\n\n")
end

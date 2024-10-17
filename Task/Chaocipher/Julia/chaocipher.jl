const leftalphabet = "HXUCZVAMDSLKPEFJRIGTWOBNYQ"
const rightalphabet = "PTLNBQDEOYSFAVZKGJRIHWXUMC"

function chacocoding(text, encoding, verbose=false)
    left, right = Vector{Char}(leftalphabet), Vector{Char}(rightalphabet)
    len, coded = length(text), similar(Vector{Char}(text))
    for i in 1:len
        verbose && println(String(left), "   ", String(right))
        n = indexin(text[i], encoding ? right : left)[1]
        coded[i] = encoding ? left[n] : right[n]
        if i < len
            left .= circshift(left, -n + 1)
            left[2:14] .= circshift(left[2:14], -1)
            right .= circshift(right, -n)
            right[3:14] .= circshift(right[3:14], -1)
        end
    end
    String(coded)
end

function testchacocipher(txt)
    println("The original plaintext is: $txt")
    println("\nThe left and right alphabets for each character during encryption are:")
    encoded = chacocoding(txt, true, true)
    println("\nThe encoded ciphertext is: $encoded")
    decoded = chacocoding(encoded, false)
    println("\nDecoded, the recovered plaintext is: $decoded")
end

testchacocipher("WELLDONEISBETTERTHANWELLSAID")

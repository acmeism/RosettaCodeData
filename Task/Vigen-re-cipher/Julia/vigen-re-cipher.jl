→(a::Char, b::Char, ± = +) = 'A'+((a-'A')±(b-'A')+26)%26
←(a::Char, b::Char) = →(a,b,-)

cleanup(str) = filter(a-> a in 'A':'Z', collect(uppercase.(str)))
match_length(word, len) = repeat(word,len)[1:len]

function →(message::String, codeword::String, ↔ = →)
    plaintext = cleanup(message)
    key = match_length(cleanup(codeword),length(plaintext))
    return String(plaintext .↔ key)
end
←(message::String, codeword::String) = →(message,codeword,←)

cyphertext = "I want spearmint gum" → "Gimme!"
println(cyphertext)
println(cyphertext ← "Gimme!")

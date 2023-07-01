def text = 'WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW'
def rleEncoded = rleEncode(text)
assert rleEncoded == '12W1B12W3B24W1B14W'
assert text == rleDecode(rleEncoded)

println "Original Text: $text"
println "Encoded Text: $rleEncoded"

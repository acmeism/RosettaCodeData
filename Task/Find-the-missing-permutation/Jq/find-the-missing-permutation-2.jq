map(encode_string) | transpose | map(parities | decode) | join("")

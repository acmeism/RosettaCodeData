CODES = {
    'a' => "AAAAA", 'b' => "AAAAB", 'c' => "AAABA", 'd' => "AAABB", 'e' => "AABAA",
    'f' => "AABAB", 'g' => "AABBA", 'h' => "AABBB", 'i' => "ABAAA", 'j' => "ABAAB",
    'k' => "ABABA", 'l' => "ABABB", 'm' => "ABBAA", 'n' => "ABBAB", 'o' => "ABBBA",
    'p' => "ABBBB", 'q' => "BAAAA", 'r' => "BAAAB", 's' => "BAABA", 't' => "BAABB",
    'u' => "BABAA", 'v' => "BABAB", 'w' => "BABBA", 'x' => "BABBB", 'y' => "BBAAA",
    'z' => "BBAAB", ' ' => "BBBAA", # use ' ' to denote any non-letter
}

def encode(plainText, message)
    pt = plainText.downcase
    et = ""
    pt.each_char { |c|
        if 'a' <= c and c <= 'z' then
            et.concat(CODES[c])
        else
            et.concat(CODES[' '])
        end
    }

    mg = message.downcase
    result = ""
    count = 0
    mg.each_char { |c|
        if 'a' <= c and c <= 'z' then
            if et[count] == 'A' then
                result.concat(c)
            else
                result.concat(c.upcase)
            end

            count = count + 1
            if count == et.length then
                break
            end
        else
            result.concat(c)
        end
    }

    return result
end

def decode(message)
    et = ""
    message.each_char { |c|
        if 'a' <= c and c <= 'z' then
            et.concat('A')
        elsif 'A' <= c and c <= 'Z' then
            et.concat('B')
        end
    }

    result = ""
    i = 0
    while i < et.length do
        quintet = et[i,5]
        for k,v in CODES do
            if v == quintet then
                result.concat(k)
                break
            end
        end

        i = i + 5
    end

    return result
end

def main
    plainText = "the quick brown fox jumps over the lazy dog"
    message = "bacon's cipher is a method of steganography created by francis bacon. " \
            + "this task is to implement a program for encryption and decryption of " \
            + "plaintext using the simple alphabet of the baconian cipher or some " \
            + "other kind of representation of this alphabet (make anything signify anything). " \
            + "the baconian alphabet may optionally be extended to encode all lower " \
            + "case characters individually and/or adding a few punctuation characters " \
            + "such as the space."

    cipherText = encode(plainText, message)
    puts "Cipher text -> ", cipherText

    decodedText = decode(cipherText)
    puts "\nHidden text ->", decodedText
end

main()

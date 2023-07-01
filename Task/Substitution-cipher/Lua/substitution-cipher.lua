-- Generate a random substitution cipher for ASCII characters 65 to 122
function randomCipher ()
    local cipher, rnd = {plain = {}, encoded = {}}
    for ascii = 65, 122 do
        table.insert(cipher.plain, string.char(ascii))
        table.insert(cipher.encoded, string.char(ascii))
    end
    for i = 1, #cipher.encoded do
        rnd = math.random(#cipher.encoded)
        cipher.encoded[i], cipher.encoded[rnd] = cipher.encoded[rnd], cipher.encoded[i]
    end
    return cipher
end

-- Encipher text using cipher.  Decipher if decode is true.
function encode (text, cipher, decode)
    local output, letter, found, source, dest = ""
    if decode then
        source, dest = cipher.encoded, cipher.plain
    else
        source, dest = cipher.plain, cipher.encoded
    end
    for pos = 1, #text do
        letter = text:sub(pos, pos)
        found = false
        for k, v in pairs(source) do
            if letter == v then
                output = output .. dest[k]
                found = true
                break
            end
        end
        if not found then output = output .. letter end
    end
    return output
end

-- Main procedure
math.randomseed(os.time())
local subCipher = randomCipher()
print("Cipher generated:")
print("\tPlain:", table.concat(subCipher.plain))
print("\tCoded:", table.concat(subCipher.encoded))
local inFile = io.open("C:\\ulua\\taskDescription.txt", "r")
local input = inFile:read("*all")
inFile:close()
local encoded = encode(input, subCipher)
print("\nEncoded file contents:")
print("\t" .. encoded)
print("\nAbove text deciphers to: ")
print("\t" .. encode(encoded, subCipher, true))

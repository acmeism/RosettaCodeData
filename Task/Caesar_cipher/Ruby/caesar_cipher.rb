@atoz = Hash.new do |hash, key|
  str = ('A'..'Z').to_a.rotate(key).join("")
  hash[key] = (str << str.downcase)
end

def encrypt(key, plaintext)
  (1..25) === key or raise ArgumentError, "key not in 1..25"
  plaintext.tr(@atoz[0], @atoz[key])
end

def decrypt(key, ciphertext)
  (1..25) === key or raise ArgumentError, "key not in 1..25"
  ciphertext.tr(@atoz[key], @atoz[0])
end

original = "THEYBROKEOURCIPHEREVERYONECANREADTHIS"
en = encrypt(3, original)
de = decrypt(3, en)

[original, en, de].each {|e| puts e}

puts 'OK' if
  (1..25).all? {|k| original == decrypt(k, encrypt(k, original))}

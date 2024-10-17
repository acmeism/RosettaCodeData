class String
  ALPHABET = ("A".."Z").to_a

  def caesar_cipher(num)
    self.tr(ALPHABET.join, ALPHABET.rotate(num).join)
  end
end

# demo
encrypted = "THEQUICKBROWNFOXJUMPSOVERTHELAZYDOG".caesar_cipher(5)
decrypted = encrypted.caesar_cipher(-5)

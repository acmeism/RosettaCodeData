class String
  ALFABET = ("A".."Z").to_a

  def caesar_cipher(num)
    self.tr(ALFABET.join, ALFABET.rotate(num).join)
  end

end

#demo:
encypted  = "THEYBROKEOURCIPHEREVERYONECANREADTHIS".caesar_cipher(3)
decrypted = encypted.caesar_cipher(-3)

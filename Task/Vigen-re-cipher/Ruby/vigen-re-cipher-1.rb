class VigenereCipher

  BASE = 'A'.ord
  SIZE = 'Z'.ord - BASE + 1

  def key=(key)
    @key = key.upcase.gsub(/[^A-Z]/, '')
  end

  def initialize(key)
    self.key= key
  end

  def encrypt(text)
    crypt(text, :+)
  end

  def decrypt(text)
    crypt(text, :-)
  end

  def crypt(text, dir)
    plaintext = text.upcase.gsub(/[^A-Z]/, '')
    key_iterator = @key.chars.cycle
    ciphertext = ''
    plaintext.each_char do |plain_char|
      offset = key_iterator.next.ord - BASE
      ciphertext +=
        ((plain_char.ord - BASE).send(dir, offset) % SIZE + BASE).chr
    end
    return ciphertext
  end

end

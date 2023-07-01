class Playfair
  Size = 5
  def initialize(key, missing)
    @missing = missing.upcase
    alphabet = ('A'..'Z').to_a.join.upcase.delete(@missing).split''
    extended = key.upcase.gsub(/[^A-Z]/,'').split('') + alphabet
    grid = extended.uniq[0...Size*Size].each_slice(Size).to_a
    coords = {}
    grid.each_with_index do |row, i|
      row.each_with_index do |letter, j|
       coords[letter] = [i,j]
      end
    end
    @encode = {}
    alphabet.product(alphabet).reject { |a,b| a==b }.each do |a, b|
      i1, j1 = coords[a]
      i2, j2 = coords[b]
      if i1 == i2 then
         j1 = (j1 + 1) % Size
         j2 = (j2 + 1) % Size
      elsif j1 == j2 then
         i1 = (i1 + 1) % Size
         i2 = (i2 + 1) % Size
      else
         j1, j2 = j2, j1
      end
      @encode["#{a}#{b}"] = "#{grid[i1][j1]}#{grid[i2][j2]}"
      @decode = @encode.invert
    end
  end

  def encode(plaintext)
    plain = plaintext.upcase.gsub(/[^A-Z]/,'')
    if @missing == 'J' then
      plain = plain.gsub(/J/, 'I')
    else
      plain = plain.gsub(@missing, 'X')
    end
    plain = plain.gsub(/(.)\1/, '\1X\1')
    if plain.length % 2 == 1 then
      plain += 'X'
    end
    return plain.upcase.split('').each_slice(2).map do |pair|
      @encode[pair.join]
    end.join.split('').each_slice(5).map{|s|s.join}.join(' ')
  end

  def decode(ciphertext)
    cipher = ciphertext.upcase.gsub(/[^A-Z]/,'')
    return cipher.upcase.split('').each_slice(2).map do |pair|
      @decode[pair.join]
    end.join.split('').each_slice(5).map{|s|s.join}.join(' ')
  end
end

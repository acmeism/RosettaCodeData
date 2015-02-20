module MoveToFront

  ABC = ("a".."z").to_a.freeze

  def self.encode(str)
    ar = ABC.dup
    str.chars.each_with_object([]) do |char, memo|
      memo << (i = ar.index(char))
      ar = m2f(ar,i)
    end
  end

  def self.decode(indices)
    ar = ABC.dup
    indices.each_with_object("") do |i, str|
      str << ar[i]
      ar = m2f(ar,i)
    end
  end

  private
  def self.m2f(ar,i)
    [ar.delete_at(i)] + ar
  end

end

['broood', 'bananaaa', 'hiphophiphop'].each do |word|
  p word == MoveToFront.decode(p MoveToFront.encode(p word))
end

class Array
  def zip_hash(other)
    Hash[*(0...self.size).inject([]) { |arr, ix|
           arr.push(self[ix], other[ix]) } ]
  end
end

hash = %W{ a b c }.zip_hash( %W{ 1 2 3 } )
p hash  # => {"a"=>"1", "b"=>"2", "c"=>"3"}

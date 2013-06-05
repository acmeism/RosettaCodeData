class Array
  def zip_hash(other)
    Hash[self.zip(other)]
  end
end

hash = %w{ a b c }.zip_hash( %w{ 1 2 3 } )
p hash  # => {"a"=>"1", "b"=>"2", "c"=>"3"}

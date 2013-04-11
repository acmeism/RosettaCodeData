class Example
  def foo
    42
  end
  def bar(arg1, arg2, &block)
    block.call arg1, arg2
  end
end

symbol = :foo
Example.new.send symbol                         # => 42
Example.new.send( :bar, 1, 2 ) { |x,y| x+y }    # => 3
args = [1, 2]
Example.new.send( "bar", *args ) { |x,y| x+y }  # => 3

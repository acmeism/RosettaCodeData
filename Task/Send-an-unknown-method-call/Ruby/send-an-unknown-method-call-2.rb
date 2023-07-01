class Example
  private
  def privacy; "secret"; end
  public
  def publicity; "hi"; end
end

e = Example.new
e.public_send :publicity  # => "hi"
e.public_send :privacy    # raises NoMethodError
e.send :privacy           # => "secret"

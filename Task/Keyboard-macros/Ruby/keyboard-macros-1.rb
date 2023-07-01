Shoes.app do
  @info = para "NO KEY is PRESSED."
  keypress do |k|
    @info.replace "#{k.inspect} was PRESSED."
  end
end

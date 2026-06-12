File.open(__FILE__) do |f|
  IO.copy(f, STDOUT)
end

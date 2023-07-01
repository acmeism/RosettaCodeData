def valid?(sailor, nuts)
  sailor.times do
    return false if (nuts % sailor) != 1
    nuts -= 1 + nuts / sailor
  end
  nuts > 0 and nuts % sailor == 0
end

[5,6].each do |sailor|
  n = sailor
  n += 1 until valid?(sailor, n)
  puts "\n#{sailor} sailors => #{n} coconuts"
  (sailor+1).times do
    div, mod = n.divmod(sailor)
    puts "  #{[n, div, mod]}"
    n -= 1 + div
  end
end

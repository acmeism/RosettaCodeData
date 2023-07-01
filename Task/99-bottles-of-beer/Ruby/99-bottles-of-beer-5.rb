99.downto(1) do |bottles|
  puts "#{bottles} bottle#{"s" if bottles != 1} of beer on the wall.",
       "#{bottles} bottle#{"s" if bottles != 1} of beer.",
       "Take one down, pass it around.",
       "#{bottles - 1} bottle#{"s" if bottles - 1 != 1} of beer on the wall.\n\n"
end

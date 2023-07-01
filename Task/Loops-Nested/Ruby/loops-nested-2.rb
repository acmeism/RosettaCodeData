p slices = [*1..20].shuffle.each_slice(4)

slices.any? do |slice|
  puts
  slice.any? do |element|
    print "#{element} "
    element == 20
  end
end
puts "done"

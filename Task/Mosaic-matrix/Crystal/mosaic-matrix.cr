def print_mosaic_matrix (n)
  n.times do |i|
    n.times do |j|
      print (i + j).even? ? " 1" : " 0"
    end
    puts
  end
end

print_mosaic_matrix 6
puts
print_mosaic_matrix 7
puts
print_mosaic_matrix 1

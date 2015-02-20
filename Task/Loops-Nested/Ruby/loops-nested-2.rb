slices = (1..20).to_a.shuffle.each_slice(4)

slices.any? do |slice|
  slice.any? do |element|
    puts element
    element == 20
  end
end

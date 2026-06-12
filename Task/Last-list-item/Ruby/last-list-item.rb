p original = [6, 81, 243, 14, 25, 49, 123, 69, 11]
until original.size == 1 do
  mins = original.min(2)
  mins.each{|el| original.delete_at(original.index(el)) }
  p original << mins.sum
end

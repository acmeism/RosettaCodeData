# each with block
[1, 2, 3].each do |elt|
  print elt
end
puts
# each returning an iterator
it = [1, 2, 3].each
print it.next, it.next, it.next, it.next

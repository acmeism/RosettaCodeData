def select(prompt, items)
  return "" if items.length == 0
  while true
    items.each_index {|i| puts "#{i}. #{items[i]}"}
    print "#{prompt}: "
    begin
      answer = Integer(gets())
    rescue ArgumentError
      redo
    end
    return items[answer] if answer.between?(0, items.length - 1)
  end
end

# test empty list
response = select("Which is empty", [])
puts "empty list returns: >#{response}<"
puts ""

# "real" test
items = ['fee fie', 'huff and puff', 'mirror mirror', 'tick tock']
response = select("Which is from the three pigs", items)
puts "you chose: >#{response}<"

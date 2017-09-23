def select(prompt, items = [])
  if items.empty?
    ''
  else
    answer = -1
    until (0...items.length).cover?(answer)
      items.each_with_index {|i,j| puts "#{j}. #{i}"}
      print "#{prompt}: "
      begin
        answer = Integer(gets)
      rescue ArgumentError
        redo
      end
    end
    items[answer]
  end
end

# test empty list
response = select('Which is empty')
puts "empty list returns: >#{response}<\n"

# "real" test
items = ['fee fie', 'huff and puff', 'mirror mirror', 'tick tock']
response = select('Which is from the three pigs', items)
puts "you chose: >#{response}<"

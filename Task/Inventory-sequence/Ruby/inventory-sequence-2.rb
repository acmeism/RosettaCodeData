def inv
  cur_count_up = (0..).to_enum
  total_counts = Hash.new(0)

  loop do
    c = total_counts[cur_count_up.next]
    total_counts[c] += 1
    yield c
    cur_count_up.rewind if c.zero?
  end
end

enum_for(:inv).first(100).each_slice(10){|s| puts "%4d"*s.size % s}
puts

ts = (1000..10000).step(1000)
enum_for(:inv).with_index do |e,i|
  if e > ts.peek
    puts "First element >= #{ts.peek} : %d index %d" % [e,i]
    ts.next
  end
end

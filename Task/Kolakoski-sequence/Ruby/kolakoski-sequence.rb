def create_generator(ar)
  Enumerator.new do |y|
    cycle = ar.cycle
    s = []
    loop do
      t = cycle.next
      s.push(t)
      v = s.shift
      y << v
      (v-1).times{s.push(t)}
    end
  end
end

def rle(ar)
  ar.slice_when{|a,b| a != b}.map(&:size)
end

[[20, [1,2]],
 [20, [2,1]],
 [30, [1,3,1,2]],
 [30, [1,3,2,1]]].each do |num,ar|
  puts "\nFirst #{num} of the sequence generated by #{ar.inspect}:"
  p res = create_generator(ar).take(num)
  puts "Possible Kolakoski sequence? #{res.join.start_with?(rle(res).join)}"
end

def ludic(nmax=100000)
  Enumerator.new do |y|
    y << 1
    ary = *2..nmax
    until ary.empty?
      y << (n = ary.first)
      (0...ary.size).step(n){|i| ary[i] = nil}
      ary.compact!
    end
  end
end

puts "First 25 Ludic numbers:", ludic.first(25).to_s

puts "Ludics below 1000:", ludic(1000).count

puts "Ludic numbers 2000 to 2005:", ludic.first(2005).last(6).to_s

ludics = ludic(250).to_a
puts "Ludic triples below 250:",
     ludics.select{|x| ludics.include?(x+2) and ludics.include?(x+6)}.map{|x| [x, x+2, x+6]}.to_s

fs = ->(f : Int32 -> Int32, s : Array(Int32)) { s.map {|elt| f[elt] } }

f1 = ->(n : Int32) { n * 2 }
f2 = ->(n : Int32) { n * n }

fsf1 = fs.partial(f1)
fsf2 = fs.partial(f2)

[(0..3).to_a, (2..8).step(2).to_a].each do |arg|
  [{fsf1, "fsf1"}, {fsf2, "fsf2"}].each do |fn , name|
    puts "#{name} #{arg} = #{fn[arg]}"
  end
  puts
end

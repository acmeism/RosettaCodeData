tens = 20.step(110, 10)
thousands = 1000.step(10_000, 1000)

10001.times do |n|
  lf = left_fact.next
  case n
  when 0..10, *tens
    puts "!#{n} = #{lf}"
  when *thousands
    puts "!#{n} has #{lf.to_s.size} digits"
  end
end

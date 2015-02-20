KRN = %w(NNRKR NRNKR NRKNR NRKRN RNNKR RNKNR RNKRN RKNNR RKNRN RKRNN)

def chess960(id=rand(960))
  pos = Array.new(8)
  q, r = id.divmod(4)
  pos[r * 2 + 1] = "B"
  q, r = q.divmod(4)
  pos[r * 2] = "B"
  q, r = q.divmod(6)
  pos[pos.each_index.reject{|i| pos[i]}[r]] = "Q"
  krn = KRN[q].each_char
  pos.each_index {|i| pos[i] ||= krn.next}
  pos.join
end

puts "Generate Start Position from id number"
[0,518,959].each do |id|
  puts "%3d : %s" % [id, chess960(id)]
end

puts "\nGenerate random Start Position"
5.times {puts chess960}

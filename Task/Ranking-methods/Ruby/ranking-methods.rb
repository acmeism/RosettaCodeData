ar = "44 Solomon
42 Jason
42 Errol
41 Garry
41 Bernard
41 Barry
39 Stephen".lines.map{|line| line.split}

grouped = ar.group_by{|pair| pair.delete_at(0).to_i}
s_rnk = 1
m_rnk =  o_rnk = f_rnk = 0
puts "stand.\tmod.\tdense\tord.\tfract."

grouped.each.with_index do |(score, names), i|
  d_rnk = i + 1
  m_rnk += names.flatten!.size
  f_rnk = (s_rnk + m_rnk)/2.0
  names.each do |name|
    o_rnk += 1
    puts "#{s_rnk}\t#{m_rnk}\t#{d_rnk}\t#{o_rnk}\t#{f_rnk.to_s.gsub(".0","")}\t#{score} #{name}"
  end
  s_rnk += names.size
end

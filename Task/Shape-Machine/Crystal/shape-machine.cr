n = if s = gets
      s.to_f
    else
      exit 1
    end

(1..).each do |i|
  prev = n
  n = (n + 3) * 0.86
  if n == prev
    puts "Quiescence achieved with #{n} after #{i} iterations"
    exit
  end
end

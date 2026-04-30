File.open("data.txt") do |f|
  f.each_line do |line|
    next if line.blank?
    puts line  if line.split[-1].to_f > 6
  end
end

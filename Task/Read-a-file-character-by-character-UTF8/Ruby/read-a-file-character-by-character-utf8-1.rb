File.open('input.txt', 'r:utf-8') do |f|
  f.each_char{|c| p c}
end

File.open('input.txt', 'r:utf-8') do |f|
  while c = f.getc
    p c
  end
end

def isbn_13? (s)
  s = s.delete("^0-9").chars.map(&.to_i)
  return false unless s.size == 13
  (s.each_step(2).sum + s.each_step(2, offset: 1).sum(&.*(3))) % 10 == 0
end

%w(978-0596528126 978-0596528120 978-1788399081 978-1788399083).each do |isbn|
  print isbn, ": ", isbn_13?(isbn), "\n"
end

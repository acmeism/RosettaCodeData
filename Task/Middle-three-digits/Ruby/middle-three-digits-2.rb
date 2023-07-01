samples = [
  123, 12345, 1234567, 987654321, 10001, -10001, -123, -100, 100, -12345,
  1, 2, -1, -10, 2002, -2002, 0
]

left_column_width = samples.map { |n| n.to_s.length }.max
samples.each do |n|
  print "%#{left_column_width}d: " % n
  begin
    puts "%03d" % middle_three_digits(n)
  rescue ArgumentError => e
    puts e
  end
end

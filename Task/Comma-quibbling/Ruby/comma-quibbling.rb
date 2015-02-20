def comma_quibbling(a)
  %w<{ }>.join(a.length < 2 ? a.first :
               "#{a[0..-2].join(', ')} and #{a[-1]}")
end

[[], %w<ABC>, %w<ABC DEF>, %w<ABC DEF G H>].each do |a|
  puts comma_quibbling(a)
end

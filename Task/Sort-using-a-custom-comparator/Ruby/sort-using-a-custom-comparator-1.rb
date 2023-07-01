words = %w(Here are some sample strings to be sorted)
p words.sort_by {|word| [-word.size, word.downcase]}

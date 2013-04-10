haystack.each do |item|
  last = haystack.rindex(item)
  if last > haystack.index(item)
    puts "#{item} last appears at index #{last}"
    break
  end
end

multi_item = haystack.each_index.group_by{|idx| haystack[idx]}.select{|key, val| val.length > 1}
# multi_item is => {"Bush"=>[4, 7]}
multi_item.each do |key, val|
  puts "#{key} appears at index #{val}"
end
#=> Bush appears at index [4, 7]

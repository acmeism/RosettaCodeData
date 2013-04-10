multi_item = haystack .each_with_index .group_by {|elem, idx| elem} .find {|key, val| val.length > 1}
# multi_item is => ["Bush", [["Bush", 4], ["Bush", 7]]]
puts "#{multi_item[0]} last appears at index #{multi_item[1][-1][1]}" unless multi_item.nil?

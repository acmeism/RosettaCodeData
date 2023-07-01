items = ["violet", "red", "green", "indigo", "blue", "yellow", "orange"]
count = 0
sortedItems = []
items.each {|item|
  puts "Inserting '#{item}' into #{sortedItems}"
  spotToInsert = sortedItems.bsearch_index{|x|
    count += 1
    print "(#{count}) Is #{item} < #{x}? "
    gets.start_with?('y')
  } || sortedItems.length # if insertion point is at the end, bsearch_index returns nil
  sortedItems.insert(spotToInsert, item)
}
p sortedItems

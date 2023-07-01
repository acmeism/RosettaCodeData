[[],[0,0,0],[1,1,1],[2,0,2]].each do |test_case|
  puts "partitions #{test_case}:"
  partition(test_case).each{|part| p part }
  puts
end

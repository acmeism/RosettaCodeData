require 'rosettacode'

total_examples = 0

RosettaCode.category_members("Programming_Tasks") do |task|
  url = RosettaCode.get_url("index.php", {"action" => "raw", "title" => task})
  examples = open(url).read.scan("=={{header").length
  puts "#{task}: #{examples}"
  total_examples += examples
end

puts
puts "Total: #{total_examples}"

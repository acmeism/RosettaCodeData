require "prime"

puts Prime.take(20).join(", ")
puts Prime.each(150).drop_while{|pr| pr < 100}.join(", ")
puts Prime.each(8000).drop_while{|pr| pr < 7700}.count
puts Prime.take(10_000).last

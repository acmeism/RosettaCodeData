closures = Array(-> Int32).new
(1..10).each do |i|
  closures << ->{ i * i }
end

puts closures[..-2].map(&.call).join(" ")

def example(foo: 0, bar: 1, grill: "pork chops")
  puts "foo is #{foo}, bar is #{bar}, and grill is #{grill}"
end

# Note that :foo is omitted and :grill precedes :bar
example(grill: "lamb kebab", bar: 3.14)

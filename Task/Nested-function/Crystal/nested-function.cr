def make_list (separator)
  counter = 1
  make_item = ->(text : String) {
    counter += 1
    "#{counter-1}#{separator}#{text}"
  }
  make_item["first"] + "\n" + make_item["second"] + "\n" + make_item["third"]
end

puts make_list ". "

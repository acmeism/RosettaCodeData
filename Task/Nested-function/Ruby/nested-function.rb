def makeList(separator)
  counter = 1

  makeItem = lambda {|item|
    result = "#{counter}#{separator}#{item}\n"
    counter += 1
    result
  }

  makeItem["first"] + makeItem["second"] + makeItem["third"]
end

print makeList(". ")

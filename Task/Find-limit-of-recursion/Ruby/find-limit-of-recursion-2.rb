def recurse n
  recurse(n+1)
rescue SystemStackError
  n
end

puts recurse(0)

# Function to make prompts nice and simple to abuse
def prompt str
  print str, ": "
  gets.chomp
end

# Get value of a
a = prompt('Enter value of a').to_i
# Get value of b
b = prompt('Enter value of b').to_i

# The dispatch hash uses the <=> operator
# When doing x<=>y:
# -1 means x is less than y
# 0 means x is equal to y
# 1 means x is greater than y
dispatch = {
  -1 => "less than",
  0 => "equal to",
  1 => "greater than"
}

# I hope you can figure this out
puts "#{a} is #{dispatch[a<=>b]} #{b}"

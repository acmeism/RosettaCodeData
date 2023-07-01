# Multi-line string constant
set input "apples, pears # and bananas
apples, pears ; and bananas"
# Do the stripping
puts [stripLineComments $input]

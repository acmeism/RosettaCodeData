class String
  def strip_comment( markers = ['#',';'] )
    re = Regexp.union( markers ) # construct a regular expression which will match any of the markers
    self[0, self =~ re] # slice the string where the regular expression matches, and return it.
  end
end

puts 'apples, pears # and bananas'.strip_comment
str = 'apples, pears ; and bananas'
puts str.strip_comment

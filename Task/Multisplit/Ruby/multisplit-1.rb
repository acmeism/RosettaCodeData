text = 'a!===b=!=c'
separators = ['==', '!=', '=']

def multisplit_simple(text, separators)
  text.split(Regexp.union(separators))
end

p multisplit_simple(text, separators) # => ["a", "", "b", "", "c"]

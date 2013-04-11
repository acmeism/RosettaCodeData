text = 'a!===b=!=c'
separators = ['==', '!=', '=']

def multisplit_simple(text, separators)
  sep_regex = Regexp.new(separators.collect {|sep| Regexp.escape(sep)}.join('|'))
  text.split(sep_regex)
end

p multisplit_simple(text, separators)
["a", "", "b", "", "c"]
=> nil
p multisplit_simple(text, ['=', '!=', '=='])
["a", "", "", "b", "", "c"]
=> nil

# Returns a copy of _s_ with rot13 encoding.
def rot13(s)
  s.tr('A-Za-z', 'N-ZA-Mn-za-m')
end

# Perform rot13 on files from command line, or standard input.
while line = ARGF.gets
  print rot13(line)
end

def multisplit_rejoin(info)
  str = info[0].zip(info[1])[0..-2].inject("") {|str, (piece, (sep, idx))| str << piece << sep}
  str << info[0].last
end

p multisplit_rejoin(multisplit(text, separators)) == text
# => true

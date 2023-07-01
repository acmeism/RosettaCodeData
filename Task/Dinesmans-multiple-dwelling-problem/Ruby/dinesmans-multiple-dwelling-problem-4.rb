N = %w(Baker Cooper Fletcher Miller Smith)
b,c,f,m,s = N

N.permutation.map{|a| a.join " "}.
grep(/(?=.*#{b}.)
      (?=.+#{c})
      (?=.+#{f}.)
      (?=.*#{c}.*#{m})
      (?=.*(#{f}..+#{s}|#{s}..+#{f}))
      (?=.*(#{f}..+#{c}|#{c}..+#{f}))/x).
first

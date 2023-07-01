require 'lcs'

def scs(u, v)
  lcs = lcs(u, v)
  u, v = u.dup, v.dup
  scs = ""
  # Iterate over the characters until LCS processed
  until lcs.empty?
    if u[0]==lcs[0] and v[0]==lcs[0]
      # Part of the LCS, so consume from all strings
      scs << lcs.slice!(0)
      u.slice!(0)
      v.slice!(0)
    elsif u[0]==lcs[0]
      # char of u = char of LCS, but char of LCS v doesn't so consume just that
      scs << v.slice!(0)
    else
      # char of u != char of LCS, so consume just that
      scs << u.slice!(0)
    end
  end
  # append remaining characters, which are not in common
  scs + u + v
end

u = "abcbdab"
v = "bdcaba"
puts "SCS(#{u}, #{v}) = #{scs(u, v)}"

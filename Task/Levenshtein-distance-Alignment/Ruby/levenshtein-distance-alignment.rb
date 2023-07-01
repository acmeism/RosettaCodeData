require 'lcs'

def levenshtein_align(a, b)
  apos, bpos = LCS.new(a, b).backtrack2

  c = ""
  d = ""
  x0 = y0 = -1
  dx = dy = 0
  apos.zip(bpos) do |x,y|
    diff = x + dx - y - dy
    if diff < 0
      dx -= diff
      c += "-" * (-diff)
    elsif diff > 0
      dy += diff
      d += "-" * diff
    end
    c += a[x0+1..x]
    x0 = x
    d += b[y0+1..y]
    y0 = y
  end

  c += a[x0+1..-1]
  d += b[y0+1..-1]
  diff = a.length + y0 - b.length - x0
  if diff < 0
    c += "-" * (-diff)
  elsif diff > 0
    d += "-" * diff
  end
  [c, d]
end

puts levenshtein_align("rosettacode", "raisethysword")

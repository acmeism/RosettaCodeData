def smallest_6(n)
  i = 1
  c = 0
  s = n.to_s
  until i.to_s.match?(s)
    c += 1
    i *= 6
  end
  [n, c, i]
end

(0..21).each{|n| puts "%3d**%-3d: %d" %  smallest_6(n) }

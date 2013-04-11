def lcs(a, b)
  matrix = Array.new(a.length) { Array.new(b.length) }
  walker = LcsWalker.new(matrix)

  a.each_char.with_index do |x, i|
    b.each_char.with_index do |y, j|
      walker.pos(i, j)
      walker.match(x, y)
    end
  end

  walker.pos(a.length-1, b.length-1)
  walker.backtrack.inject("") { |s, i| s.prepend(a[i]) }
end

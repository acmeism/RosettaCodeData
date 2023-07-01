van_eck = Enumerator.new do |y|
  ar = [0]
  loop do
    y << (term = ar.last)  # yield
    ar << (ar.count(term)==1 ? 0 : ar.size - 1 - ar[0..-2].rindex(term))
  end
end

ve = van_eck.take(1000)
p ve.first(10), ve.last(10)

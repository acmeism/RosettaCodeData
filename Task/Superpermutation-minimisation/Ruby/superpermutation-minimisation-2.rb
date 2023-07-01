def superperm(n)
  return [1] if n==1
  superperm(n-1).each_cons(n-1).with_object([]) do |sub, ary|
    next if sub.uniq!
    i = ary.empty? ? 0 : sub.index(ary.last)+1
    ary.concat(sub[i..-1] + [n] + sub)
  end
end

def to_16(a) a.map{|x| x.to_s(16)}.join end

for n in 1..10
  ary = superperm(n)
  print "%3d: len =%8d :" % [n, ary.size]
  puts n<5 ? ary.join : to_16(ary.first(20)) + "...." + to_16(ary.last(20))
end

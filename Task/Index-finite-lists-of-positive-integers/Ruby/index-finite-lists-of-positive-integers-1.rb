def rank(arr)
  arr.join('a').to_i(11)
end

def unrank(n)
  n.to_s(11).split('a').map(&:to_i)
end

l = [1, 2, 3, 10, 100, 987654321]
p l
n = rank(l)
p n
l = unrank(n)
p l

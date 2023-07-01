require "set"
require "big"

def add_reverse(num, max_iter=1000)
  num = num.to_big_i
  nums = [] of BigInt
  (1..max_iter).each_with_object(Set.new([num])) do |_, nums|
    num += reverse_int(num)
    nums << num
    return nums if palindrome?(num)
  end
end

def palindrome?(num)
  num == reverse_int(num)
end

def reverse_int(num)
  num.to_s.reverse.to_big_i
end

def split_roots_from_relateds(roots_and_relateds)
  roots = roots_and_relateds.dup
  i = 1
  while i < roots.size
    this = roots[i]
    if roots[0...i].any?{ |prev| this.intersects?(prev) }
      roots.delete_at(i)
    else
      i += 1
    end
  end
  root = roots.map{ |each_set| each_set.min }
  related = roots_and_relateds.map{ |each_set| each_set.min }
  related = related.reject{ |n| root.includes?(n) }
  return root, related
end

def find_lychrel(maxn, max_reversions)
  series = (1..maxn).map{ |n| add_reverse(n, max_reversions*2) }
  roots_and_relateds = series.select{ |s| s.size > max_reversions }
  split_roots_from_relateds(roots_and_relateds)
end

maxn, reversion_limit = 10000, 500
puts "Calculations using n = 1..#{maxn} and limiting each search to 2*#{reversion_limit} reverse-digits-and-adds"
lychrel, l_related = find_lychrel(maxn, reversion_limit)
puts "  Number of Lychrel numbers: #{lychrel.size}"
puts "    Lychrel numbers: #{lychrel}"
puts "  Number of Lychrel related: #{l_related.size}"
pals = (lychrel + l_related).select{|x| palindrome?(x)}.sort
puts "  Number of Lychrel palindromes: #{pals.size}"
puts "    Lychrel palindromes: #{pals}"

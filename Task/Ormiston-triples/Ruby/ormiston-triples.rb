require 'prime'

def all_anagram?(arr)
  sorted = arr.first.digits.sort
  arr[1..].all?{|a| a.digits.sort == sorted}
end

res = Prime.each.each_cons(3).lazy.filter_map{|ar| ar.first if all_anagram?(ar)}.first(25)
res.each_slice(5){|slice| puts slice.join(", ")}

n = 1E9
res = Prime.each(n).each_cons(3).count {|ar| all_anagram?(ar)}
puts "\nThere are #{res} Ormiston triples below #{n}"

# Generate IPF triangle
# Nigel_Galloway: May 1st., 2013.
def g(n,g)
  return 1 unless 1 < g and g < n-1
  (2..g).inject(1){|res,q| res + (q > n-g ? 0 : g(n-g,q))}
end

(1..25).each {|n|
  puts (1..n).map {|g| "%4s" % g(n,g)}.join
}

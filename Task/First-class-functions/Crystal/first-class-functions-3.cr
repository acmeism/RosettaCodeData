def cube (n)
  n*n*n
end

add1 = ->(n : Float64) { n + 1 }
sub1 = ->(n : Float64) { n - 1 }

a = [ ->Math.sin(Float64),  ->Math.cos(Float64),  ->cube(Float64),      add1 ]
b = [ ->Math.asin(Float64), ->Math.acos(Float64), ->Math.cbrt(Float64), sub1 ]
s = [ "sin o asin",         "cos o acos",         "cube o cbrt", "add1 o sub1"]

def compose (f, g)
  ->(n : Float64) { f[ g[n] ] }
end

composed = a.zip(b).map {|(f, g)| compose(f, g) }

composed.each_with_index do |f, i|
  puts "(#{s[i]})(0.5) = #{ f[0.5] }"
end

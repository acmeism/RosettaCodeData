y = lambda do |f|
  lambda {|*args| f[y[f]][*args]}
end

Indexable.each_cartesian([[-5, 5], [2, 3]]).each do |(x, p)|
  printf "x =%2d p=%2d   ", x, p
  [{"-x**p",   -x**p},   {"-(x)**p", -(x)**p},
   {"(-x)**p", (-x)**p}, {"-(x**p)", -(x**p)}].each do |sr|
    print "%s %4d   " % sr
  end
  puts
end

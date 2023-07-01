def zeckendorf(n)
  0.step.lazy.map { |x| x.to_s(2) }.reject { |z| z.include?("11") }.first(n)
end

zeckendorf(21).each_with_index{ |x,i| puts "%3d: %8s"% [i, x] }

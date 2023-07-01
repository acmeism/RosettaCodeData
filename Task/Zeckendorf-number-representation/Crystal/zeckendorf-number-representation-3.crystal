def zeckendorf(n)
  0.step.map(&.to_s(2)).reject(&.includes?("11")).first(n)
end

# or a little faster

def zeckendorf(n)
  0.step.compact_map{ |x| bin = x.to_s(2); bin unless bin.includes?("11") }.first(n)
end

zeckendorf(21).each_with_index{ |x,i| puts "%3d: %8s"% [i, x] }

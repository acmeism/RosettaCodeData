grouped =  (1..13).to_a.repeated_permutation(3).group_by do |a,b,c|
  sumaabb, ab = a*a + b*b, a*b
  case c*c
    when sumaabb      then 90
    when sumaabb - ab then 60
    when sumaabb + ab then 120
  end
end

grouped.delete(nil)
res = grouped.transform_values{|v| v.map(&:sort).uniq }

res.each do |k,v|
  puts "For an angle of #{k} there are #{v.size} solutions:"
  puts v.inspect, "\n"
end

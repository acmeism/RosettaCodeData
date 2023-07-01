[true,false].product([true,false]).each do |cond1, cond2|
  print "%5s, %5s => " % [cond1, cond2]
  if2(cond1, cond2) do
    puts "both true"
  end.else1 do
    puts "first is true"
  end.else2 do
    puts "second is true"
  end.neither do
    puts "neither is true"
  end
end

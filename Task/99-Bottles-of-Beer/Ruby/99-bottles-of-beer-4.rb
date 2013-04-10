def bottles(beer, wall = false)
  "#{beer>0 ? beer : "no more"} bottle#{"s" if beer!=1} of beer#{" on the wall" if wall}"
end

99.downto(0) do |remaining|
  puts "#{bottles(remaining,true).capitalize}, #{bottles(remaining)}."
  if remaining==0
    print "Go to the store and buy some more"
    remaining=100
  else
    print "Take one down, pass it around"
  end
  puts ", #{bottles(remaining-1,true)}.\n\n"
end

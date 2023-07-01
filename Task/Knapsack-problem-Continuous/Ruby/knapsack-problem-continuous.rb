items = [ [:beef   , 3.8, 36],
          [:pork   , 5.4, 43],
          [:ham    , 3.6, 90],
          [:greaves, 2.4, 45],
          [:flitch , 4.0, 30],
          [:brawn  , 2.5, 56],
          [:welt   , 3.7, 67],
          [:salami , 3.0, 95],
          [:sausage, 5.9, 98] ].sort_by{|item, weight, price| -price / weight}
maxW, value = 15.0, 0
items.each do |item, weight, price|
  if (maxW -= weight) > 0
    puts "Take all #{item}"
    value += price
  else
    puts "Take %gkg of %s" % [t=weight+maxW, item], "",
         "Total value of swag is %g" % (value+(price/weight)*t)
    break
  end
end

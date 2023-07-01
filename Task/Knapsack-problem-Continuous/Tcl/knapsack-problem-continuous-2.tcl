set items {
    {beef	3.8	36}
    {pork	5.4	43}
    {ham	3.6	90}
    {greaves	2.4	45}
    {flitch	4.0	30}
    {brawn	2.5	56}
    {welt	3.7	67}
    {salami	3.0	95}
    {sausage	5.9	98}
}

lassign [continuousKnapsack $items 15.0] contents totalValue
puts [format "total value of knapsack: %.2f" $totalValue]
puts "contents:"
foreach item $contents {
    lassign $item name mass value
    puts [format "\t%.1fkg of %s, value %.2f" $mass $name $value]
}

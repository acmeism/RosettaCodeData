gifts = "A partridge in a pear tree
Two turtle doves and
Three french hens
Four calling birds
Five golden rings
Six geese a-laying
Seven swans a-swimming
Eight maids a-milking
Nine ladies dancing
Ten lords a-leaping
Eleven pipers piping
Twelve drummers drumming".split("\n")

days = %w(first second third fourth fifth sixth
seventh eighth ninth tenth eleventh twelfth)

days.each_with_index do |day, i|
  puts "On the #{day} day of Christmas"
  puts "My true love gave to me:"
  puts gifts[0, i+1].reverse
  puts
end

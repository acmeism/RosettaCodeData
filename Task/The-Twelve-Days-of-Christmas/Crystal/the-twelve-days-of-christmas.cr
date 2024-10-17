days = "first second third fourth fifth sixth seventh eighth ninth tenth eleventh twelfth".split " "
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
Twelve drummers drumming".split "\n"

days.each_with_index do |day, i|
    puts "On the #{day} day of Christmas\nMy true love gave to me:"
    gifts[0, i + 1].reverse.each &->puts(String)
    puts
end

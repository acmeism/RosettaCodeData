gifts = """
A partridge in a pear tree
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
Twelve drummers drumming
""" |> String.split("\n", trim: true)

days = ~w(first second third fourth fifth sixth seventh eighth ninth tenth eleventh twelfth)

Enum.with_index(days) |> Enum.each(fn {day, i} ->
  IO.puts "On the #{day} day of Christmas"
  IO.puts "My true love gave to me:"
  Enum.take(gifts, i+1) |> Enum.reverse |> Enum.each(&IO.puts &1)
  IO.puts ""
end)

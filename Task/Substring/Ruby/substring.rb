str = 'abcdefgh'
n = 2
m = 3
puts str[n, m]
puts str[n..-1]
puts str[0..-2]
puts str[str.index('d'), m]
puts str[str.index('de'), m]
puts str[/a.*d/]

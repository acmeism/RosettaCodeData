s == ""
s.eql?("")
s.empty?
s.length == 0
s[/\A\z/]

# also silly things like
s.each_char.to_a.empty?

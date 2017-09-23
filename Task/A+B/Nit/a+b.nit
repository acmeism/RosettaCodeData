module ab

var words = gets.split(" ")
if words.length != 2 then
	print "Expected two numbers"
	return
end
print words[0].to_i + words[1].to_i

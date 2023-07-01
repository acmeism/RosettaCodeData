def welcome(name)
   puts "hello #{name}"
end
puts "What is your name?"
$name = STDIN.gets
welcome($name)
return

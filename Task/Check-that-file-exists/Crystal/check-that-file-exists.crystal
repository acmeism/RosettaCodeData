def check_file(filename : String)
  if File.directory?(filename)
    puts "#{filename} is a directory"
  elsif File.exists?(filename)
    puts "#{filename} is a file"
  else
    puts "#{filename} does not exist"
  end
end

check_file("input.txt")
check_file("docs")
check_file("/input.txt")
check_file("/docs")

def setup(start, remove)
  puts "remove #{remove} lines starting at line #{start}"
  File.open($filename, "w") {|fh| (1..5).each {|i| fh.puts i}}
  puts "before:\n" + File.read($filename)
end

def teardown
  puts "after:\n" + File.read($filename)
  puts ""
  File.unlink($filename)
end

$filename = "test.file"
start = 2
[2, 6].each do |remove|
  setup(start, remove)
  remove_lines $filename, start, remove
  teardown
end

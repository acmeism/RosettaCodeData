def text_between (s, start_delim, end_delim)
  start_delim = start_delim == "start" ? "^" : Regex.escape(start_delim)
  end_delim =   end_delim   == "end"   ? "$" : Regex.escape(end_delim)
  s =~ /#{start_delim}(.*?)(?:#{end_delim}|$)/ && $1 || ""
end

rosetta = "Hello Rosetta Code world"

[{rosetta, "Hello ", " world"}, {rosetta, "start", " world"}, {rosetta, "Hello", "end"},
 {"</div><div style=\"chinese\">你好嗎</div>", "<div style=\"chinese\">", "</div>"},
 {"<text>Hello <span>Rosetta Code</span> world</text><table style=\"myTable\">", "<text>", "<table>"},
 {"<table style=\"myTable\"><tr><td>hello world</td></tr></table>", "<table>", "</table>"},
 {"The quick brown fox jumps over the lazy other fox", "quick ", " fox"},
 {"One fish two fish red fish blue fish", "fish ", " red"},
 {"FooBarBazFooBuxQuux", "Foo", "Foo"}
].each do |s, start_delim, end_delim|
  puts "Text: #{s.inspect}"
  puts "Start delimiter: #{start_delim.inspect}"
  puts "End delimiter: #{end_delim.inspect}"
  puts "Output: #{text_between(s, start_delim, end_delim).inspect}"
  puts
end

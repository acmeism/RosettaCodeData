def testdata:
  (["Hello Rosetta Code world", "Hello ", " world"],
   ["Hello Rosetta Code world", "start", " world"],
   ["Hello Rosetta Code world", "Hello", "end"],
   ["</div><div style=\"chinese\">你好嗎</div>", "<div style=\"chinese\">", "</div>"],
   ["<text>Hello <span>Rosetta Code</span> world</text><table style=\"myTable\">", "<text>", "<table>"],
   ["<table style=\"myTable\"><tr><td>hello world</td></tr></table>", "<table>", "</table>"],
   ["The quick brown fox jumps over the lazy other fox", "quick ", " fox"],
   ["One fish two fish red fish blue fish", "fish ", " red"],
   ["FooBarBazFooBuxQuux", "Foo", "Foo"] )
   ;
	
testdata
| . as $in
| $in[0]
| textbetween_strings($in[1]; $in[2])

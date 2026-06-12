function textbetween(text, sdelim, edelim)
  -- case #5 (end delimiter not present) is only problem for simplest approach, so preprocess:
  if not text:find(edelim=="end" and "$" or edelim) then edelim = "end" end
  -- then just:
  local re = (sdelim=="start" and "^" or sdelim) .. "(.-)" .. (edelim=="end" and "$" or edelim)
  return text:match(re) or ""
end

function test(text, sdelim, edelim, expected)
  print(textbetween(text, sdelim, edelim) == expected)
end

test( "Hello Rosetta Code world", "Hello ", " world", "Rosetta Code" )
test( "Hello Rosetta Code world", "start", " world", "Hello Rosetta Code" )
test( "Hello Rosetta Code world", "Hello ", "end", "Rosetta Code world" )
test( "</div><div style=\"french\">bonjour</div>", "<div style=\"french\">", "</div>", "bonjour" )
test( "<text>Hello <span>Rosetta Code</span> world</text><table style=\"myTable\">", "<text>", "<table>", "Hello <span>Rosetta Code</span> world</text><table style=\"myTable\">" )
test( "<table style=\"myTable\"><tr><td>hello world</td></tr></table>", "<table>", "</table>", "" )
test( "The quick brown fox jumps over the lazy other fox", "quick ", " fox", "brown" )
test( "One fish two fish red fish blue fish", "fish ", " red", "two fish" )
test( "FooBarBazFooBuxQuux", "Foo", "Foo", "BarBaz" )

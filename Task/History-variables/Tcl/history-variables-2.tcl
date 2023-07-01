# Enable history for foo
histvar foo start
set foo {a b c d}
set foo 123
set foo "quick brown fox"
puts $foo
puts foo-history=[join [histvar foo list] ", "]
puts $foo
histvar foo undo
puts $foo
histvar foo undo
puts $foo
histvar foo stop

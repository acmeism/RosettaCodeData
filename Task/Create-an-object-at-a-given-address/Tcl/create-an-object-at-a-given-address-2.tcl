package require machAddrDemo
set addr [linkvar foo]
puts "var 'foo' at $addr with value $foo"
linkagain $addr bar
puts "var 'bar' at $addr with value $bar"
incr foo
puts "incremented 'foo' so 'bar' is $bar"

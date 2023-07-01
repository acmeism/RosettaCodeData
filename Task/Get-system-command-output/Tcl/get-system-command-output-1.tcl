set data [exec ls -l]
puts "read [string length $data] bytes and [llength [split $data \n]] lines"

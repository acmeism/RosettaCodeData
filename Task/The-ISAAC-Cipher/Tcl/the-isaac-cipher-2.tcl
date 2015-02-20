set key "this is my secret key"
set msg "a Top Secret secret"
ISAAC create demo $key
puts "Message: $msg"
puts "Key    : $key"
puts "XOR    : [demo vernam $msg]"

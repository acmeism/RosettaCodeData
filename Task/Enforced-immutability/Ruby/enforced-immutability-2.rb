# There are two methods in the copy of the object.
msg = "Hello World!".freeze
msg2 = msg.clone        # Copies the frozen and tainted state of obj.
msg3 = msg.dup          # It doesn't copy the status (frozen, tainted) of obj.
puts msg2               #=> Hello World!
puts msg3               #=> Hello World!
puts msg2.frozen?       #=> true
puts msg3.frozen?       #=> false

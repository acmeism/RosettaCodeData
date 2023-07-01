require 'fiddle'

# Find strdup().  It takes a pointer and returns a pointer.
strdup = Fiddle::Function
           .new(Fiddle::Handle['strdup'],
                [Fiddle::TYPE_VOIDP], Fiddle::TYPE_VOIDP)

# Call strdup().
#   - It converts our Ruby string to a C string.
#   - It returns a Fiddle::Pointer.
duplicate = strdup.call("This is a string!")
puts duplicate.to_s     # Convert the C string to a Ruby string.
Fiddle.free duplicate   # free() the memory that strdup() allocated.

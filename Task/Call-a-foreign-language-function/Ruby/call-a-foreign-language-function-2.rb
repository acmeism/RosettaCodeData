require 'dl'
require 'fiddle'

# Declare strdup().
#  * DL::Handle['strdup'] is the address of the function.
#  * The function takes a pointer and returns a pointer.
strdup = Fiddle::Function.new(DL::Handle['strdup'],
                              [DL::TYPE_VOIDP], DL::TYPE_VOIDP)

# Call strdup().
#  * Fiddle converts our Ruby string to a C string.
#  * Fiddle returns a DL::CPtr.
duplicate = strdup.call("This is a string!")

# DL::CPtr#to_s converts our C string to a Ruby string.
puts duplicate.to_s

# We must call free(), because strdup() allocated memory.
DL.free duplicate

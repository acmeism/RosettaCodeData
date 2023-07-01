# query.rb
require 'fiddle'

# Look for a C variable named QueryPointer.
# Raise an error if it is missing.
c_var = Fiddle.dlopen(nil)['QueryPointer']

int = Fiddle::TYPE_INT
voidp = Fiddle::TYPE_VOIDP
sz_voidp = Fiddle::SIZEOF_VOIDP

# Implement the C function
#   int Query(void *data, size_t *length)
# in Ruby code.  Store it in a global constant in Ruby (named Query)
# to protect it from Ruby's garbage collector.
#
Query = Fiddle::Closure::BlockCaller
          .new(int, [voidp, voidp]) do |datap, lengthp|
  message = "Here am I"

  # We got datap and lengthp as Fiddle::Pointer objects.
  # Read length, assuming sizeof(size_t) == sizeof(void *).
  length = lengthp[0, sz_voidp].unpack('J').first

  # Does the message fit in length bytes?
  if length < message.bytesize
    0  # failure
  else
    length = message.bytesize
    datap[0, length] = message  # Copy the message.
    lengthp[0, sz_voidp] = [length].pack('J')  # Update the length.
    1  # success
  end
end

# Set the C variable to our Query.
Fiddle::Pointer.new(c_var)[0, sz_voidp] = [Query.to_i].pack('J')

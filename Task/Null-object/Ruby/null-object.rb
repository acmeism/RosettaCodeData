puts "@object is nil" if @object.nil?		# instance variable

puts "$object is nil" if $object.nil?		# global variable, too

# It recognizes as the local variable even if it isn't executed.
object = 1  if false
puts "object is nil" if object.nil?

# nil itself is an object:
puts nil.class  # => NilClass

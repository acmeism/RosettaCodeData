# An enum is a set of integer values, where each value has an associated name.
# For example:

enum Color
  Red   # 0
  Green # 1
  Blue  # 2
end

# Values start with the value 0 and are incremented by one,
# but can be overwritten.

# To get the underlying value you invoke value on it:

Color::Green.value # => 1

# Each constant (member) in the enum has the type of the enum:

typeof(Color::Red) # => Color

# An enum can be marked with the @[Flags] annotation.
# This changes the default values:

@[Flags]
enum IOMode
  Read  # 1
  Write # 2
  Async # 4
end

# Additionally, some methods change their behaviour.

# An enum can be created from an integer:

Color.new(1).to_s # => "Green"

# Values that don't correspond to enum's constants are allowed:
# the value will still be of type Color, but when printed you will get
# the underlying value:

Color.new(10).to_s # => "10"

# This method is mainly intended to convert integers from C to enums in Crystal.

# An enum automatically defines question methods for each member,
# using String#underscore for the method name.
#  * In the case of regular enums, this compares by equality (#==).
#  * In the case of flags enums, this invokes #includes?.
# For example:

color = Color::Blue
color.red?  # => false
color.blue? # => true

mode = IOMode::Read | IOMode::Async
mode.read?  # => true
mode.write? # => false
mode.async? # => true

# This is very convenient in case expressions:

case color
when .red?
  puts "Got red"
when .blue?
  puts "Got blue"
end

# The type of the underlying enum value is Int32 by default,
# but it can be changed to any type in Int::Primitive.

enum Color : UInt8
  Red
  Green
  Blue
end

Color::Red.value # : UInt8

puts "OK!"                      # Kernel#puts
raise "Error input"             # Kernel#raise
Integer("123")                  # Kernel#Integer
rand(6)                         # Kernel#rand
throw(:exit)                    # Kernel#throw

# method which can be seen like a reserved word.
attr_accessor                   # Module#attr_accessor
include                         # Module#include
private                         # Module#private
require                         # Kernel#require
loop { }                        # Kernel#loop

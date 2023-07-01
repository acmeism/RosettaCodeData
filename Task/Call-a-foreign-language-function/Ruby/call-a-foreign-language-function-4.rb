require 'ffi'

module LibC
  extend FFI::Library
  ffi_lib FFI::Platform::LIBC

  attach_function :strdup, [:string], :pointer
  attach_function :free, [:pointer], :void
end

string = "Hello, World!"
duplicate = LibC.strdup(string)
puts duplicate.get_string(0)
LibC.free(duplicate)

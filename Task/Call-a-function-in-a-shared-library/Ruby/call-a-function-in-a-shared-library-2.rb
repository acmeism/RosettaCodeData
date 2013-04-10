require 'ffi'
module FakeImgLib
  extend FFI::Library
  ffi_lib "path/to/fakeimglib.so"
  attach_function :openimage, [:string], :int
end

handle = FakeImgLib.openimage("path/to/image")

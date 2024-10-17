@[Link("c")] # name of library that is passed to linker. Not needed as libc is linked by stdlib.
lib LibC
  fun free(ptr : Void*) : Void
  fun strdup(ptr : Char*) : Char*
end

s1 = "Hello World!"
p = LibC.strdup(s1) # returns Char* allocated by LibC
s2 = String.new(p)
LibC.free p # pointer can be freed as String.new(Char*) makes a copy of data

puts s2

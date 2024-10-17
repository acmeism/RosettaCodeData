libm = LibC.dlopen("libm.so.6", LibC::RTLD_LAZY)
sqrtptr = LibC.dlsym(libm, "sqrt") unless libm.null?

if sqrtptr
  sqrtproc = Proc(Float64, Float64).new sqrtptr, Pointer(Void).null
  at_exit { LibC.dlclose(libm) }
else
  sqrtproc = ->Math.sqrt(Float64)
end

puts "the sqrt of 4 is #{sqrtproc.call(4.0)}"

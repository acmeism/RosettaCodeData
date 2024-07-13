local
  val libc = Foreign.loadLibrary "libc.so.6"
  val sym = Foreign.getSymbol libc "strdup"
in
  val strdup = Foreign.buildCall1(sym, (Foreign.cString), Foreign.cString)
end

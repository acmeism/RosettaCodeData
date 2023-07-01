$ffi = FFI::cdef("char *_strdup(const char *strSource);", "msvcrt.dll");

$cstr = $ffi->_strdup("success");
$str = FFI::string($cstr);
echo $str;
FFI::free($cstr);

s = .s~new
s2 = s~copy   -- makes a copy of the first
if s == s2 then say "copy didn't work!"
if s2~name == "S" then say "polymorphic copy worked"

::class t
::method name
  return "T"

::class s subclass t
::method name
  return "S"

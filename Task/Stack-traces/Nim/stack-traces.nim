proc g() =
  writeStackTrace()
proc f() =
  g()

f()

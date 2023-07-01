proc openimage(s: cstring): cint {.importc, dynlib: "./fakeimglib.so".}

echo openimage("foo")
echo openimage("bar")
echo openimage("baz")

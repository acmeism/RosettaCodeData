proc openimage(s: string): int {.importc, dynlib: "./libfakeimg.so".}

echo openimage("foo")
echo openimage("bar")
echo openimage("baz")

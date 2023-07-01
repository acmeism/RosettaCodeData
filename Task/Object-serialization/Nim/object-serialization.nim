import marshal, streams

type
  Base = object of RootObj
    name: string
  Descendant = object of Base
proc newBase(): Base = Base(name: "base")
proc newDescendant(): Descendant = Descendant(name: "descend")
proc print(obj: Base) =
  echo(obj.name)

var
  base = newBase()
  descendant = newDescendant()
print(base)
print(descendant)

var strm = newFileStream("objects.dat", fmWrite)
store(strm, (base, descendant))
strm.close()

var t: (Base, Descendant)
load(newFileStream("objects.dat", fmRead), t)
print(t[0])
print(t[1])

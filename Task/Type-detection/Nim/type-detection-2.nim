type Kind = enum kString, kFile

type Source = object
  case kind: Kind
  of kString: str: string
  of kFile: file: File

proc writeText(source: Source) =
  case source.kind
  of kString: echo source.str
  of kFile: echo source.file.readAll()

let s1 = Source(kind: kString, str: "Hello world!")
let s2 = Source(kind: kFile, file: stdin)

s1.writeText()
s2.writeText()

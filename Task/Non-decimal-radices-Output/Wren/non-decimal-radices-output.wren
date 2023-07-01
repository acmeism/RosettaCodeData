import "/fmt" for Conv, Fmt

System.print("     2    7    8   10   12   16   32")
System.print("------ ---- ---- ---- ---- ---- ----")
for (i in 1..33) {
    var b2  = Fmt.b(6, i)
    var b7  = Fmt.s(4, Conv.itoa(i, 7))
    var b8  = Fmt.o(4, i)
    var b10 = Fmt.d(4, i)
    var b12 = Fmt.s(4, Conv.Itoa(i, 12))
    var b16 = Fmt.X(4, i)
    var b32 = Fmt.s(4, Conv.Itoa(i, 32))
    System.print("%(b2) %(b7) %(b8) %(b10) %(b12) %(b16) %(b32)")
}

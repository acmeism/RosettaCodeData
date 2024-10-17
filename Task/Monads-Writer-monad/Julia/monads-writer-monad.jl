struct Writer x::Real; msg::String; end

Base.show(io::IO, w::Writer) = print(io, w.msg, ": ", w.x)

unit(x, logmsg) = Writer(x, logmsg)

bind(f, fmsg, w) = unit(f(w.x), w.msg * ", " * fmsg)

f1(x) = 7x
f2(x) = x + 8

a = unit(3, "after intialization")
b = bind(f1, "after times 7 ", a)
c = bind(f2, "after plus 8", b)

println("$a => $b => $c")
println(bind(f2, "after plus 8", bind(f1, "after times 7", unit(3, "after intialization"))))

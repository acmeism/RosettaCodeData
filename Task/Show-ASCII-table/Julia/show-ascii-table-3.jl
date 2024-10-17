print("\e[2J")          # clear screen
print("""
                    0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F
                  ╔═══╤═══╤═══╤═══╤═══╤═══╤═══╤═══╤═══╤═══╤═══╤═══╤═══╤═══╤═══╤═══╗
                  ║nul│soh│stx│etx│eot│enq│ack│bel│ bs│tab│ lf│ vt│ ff│ cr│ so│ si║
                """)    # indent is set by this (least indented) line
for i = 0:14
    a = string(i,base=16)
println(      "$a ║   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   ║ $a")
println(       "  ╟───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───╢")
println(i==0 ? "  ║dle│dc1│dc2│dc3│dc4│nak│syn│etb│can│ em│eof│esc│ fs│ gs│ rs│ us║"
             : "  ║   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   ║")
end
println("""
                f ║   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   ║ f
                  ╚═══╧═══╧═══╧═══╧═══╧═══╧═══╧═══╧═══╧═══╧═══╧═══╧═══╧═══╧═══╧═══╝
                    0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F
                """)    # """ string is indented here
for i = 1:255
    r,c = divrem(i,16)
    r,c = 3r+4,4c+5
    i > 31 && print("\e[$(r-1);$(c-1)H$(lpad(i,3))")
    6<i<11 || i==155 || i==173 || print("\e[$r;$(c)H$(Char(i))")
end
print("\e[54;1H")

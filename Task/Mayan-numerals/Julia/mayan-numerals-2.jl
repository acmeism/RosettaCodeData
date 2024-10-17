mayan_glyphs(x, y) = (x == 0 && y == 0) ? "\n| style=$tdconfig | Θ" : "\n| style=$tdconfig | " * "●" ^ x * "<br>───" ^ y

inttomayan(n) = (s = string(n, base=20); map(ch -> reverse(divrem(parse(Int, ch, base=20), 5)), split(s, "")))

tableconfig = raw""" " border: 1px solid DarkOrange;   border-radius: 13px;   border-spacing: 1; " """
tdconfig = raw""" "border: 2px solid DarkOrange; border-radius: 13px; border-bottom: 2px solid DarkOrange; vertical-align: bottom; text-align: center; padding: 10px;" """

function testmayan()
    txt = ""
    for n in [4005, 8017, 326205, 886205, 70913241, 2147483647]
        txt *= "\n'''The Mayan representation for the integer $n is:'''\n" *
               "{| style=$tableconfig \n|- " *
               join(map(x -> mayan_glyphs(x[1], x[2]), inttomayan(n))) * "\n|}\n\n"
    end
    println(txt)
end

testmayan()

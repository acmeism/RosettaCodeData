procedure main(A)
    s1 := RealSet("(0,1]").union(RealSet("[0,2)"))
    s2 := RealSet("[0,2)").intersect(RealSet("(1,2)"))
    s3 := RealSet("[0,3)").difference(RealSet("(0,1)"))
    s4 := RealSet("[0,3)").difference(RealSet("[0,1]"))
    every s := s1|s2|s3|s4 do {
        every n := 0 to 2 do
            write(s.toString(),if s.contains(n) then " contains "
                                                else " doesn't contain ",n)
        write()
        }
end

class Range(a,b,lbnd,rbnd,ltest,rtest)

    method contains(x); return ((ltest(a,x),rtest(x,b)),self); end
    method toString(); return lbnd||a||","||b||rbnd; end
    method notEmpty(); return (ltest(a,b),rtest(a,b),self); end
    method makeLTest(); return proc(if lbnd == "(" then "<" else "<=",2); end
    method makeRTest(); return proc(if rbnd == "(" then "<" else "<=",2); end

    method intersect(r)
        if a < r.a then (na := r.a, nlb := r.lbnd)
        else if a > r.a then (na := a, nlb := lbnd)
        else (na := a, nlb := if "(" == (lbnd|r.lbnd) then "(" else "[")
        if b < r.b then ( nb := b, nrb := rbnd)
        else if b > r.b then (nb := r.b, nrb := r.rbnd)
        else (nb := b, nrb := if ")" == (rbnd|r.rbnd) then ")" else "]")
        range := Range(nlb||na||","||nb||nrb)
        return range
    end

    method difference(r)
        if /r then return RealSet(toString())
        r1 := lbnd||a||","||min(b,r.a)||map(r.lbnd,"([","])")
        r2 := map(r.rbnd,")]","[(")||max(a,r.b)||","||b||rbnd
        return RealSet(r1).union(RealSet(r2))
    end

initially(s)
    static lbnds, rbnds
    initial (lbnds := '([', rbnds := '])')
    if \s then {
        s ? {
            lbnd := (tab(upto(lbnds)),move(1))
            a := 1(tab(upto(',')),move(1))
            b := tab(upto(rbnds))
            rbnd := move(1)
            }
        ltest := proc(if lbnd == "(" then "<" else "<=",2)
        rtest := proc(if rbnd == ")" then "<" else "<=",2)
        }
end

class RealSet(ranges)

    method contains(x); return ((!ranges).contains(x), self); end
    method notEmpty(); return ((!ranges).notEmpty(), self); end

    method toString()
        sep := s := ""
        every r := (!ranges).toString() do s ||:= .sep || 1(r, sep := " + ")
        return s
    end

    method clone()
        newR := RealSet()
        newR.ranges := (copy(\ranges) | [])
        return newR
    end

    method union(B)
        newR := clone()
        every put(newR.ranges, (!B.ranges).notEmpty())
        return newR
    end

    method intersect(B)
        newR := clone()
        newR.ranges := []
        every (r1 := !ranges, r2 := !B.ranges) do {
            range := r1.intersect(r2)
            put(newR.ranges, range.notEmpty())
            }
        return newR
    end

    method difference(B)
        newR := clone()
        newR.ranges := []
        every (r1 := !ranges, r2 := !B.ranges) do {
            rs := r1.difference(r2)
            if rs.notEmpty() then every put(newR.ranges, !rs.ranges)
            }
        return newR
    end

initially(s)
    put(ranges := [],Range(\s).notEmpty())
end

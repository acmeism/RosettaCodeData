class Church { // identity Church function by default
    proc this(f: shared Church): shared Church { return f; }
}

// utility Church functions...
class ComposeChurch : Church {
    const l, r: shared Church;
    override proc this(f: shared Church): shared Church {
        return l(r(f)); }
}

proc composeChurch(chl: shared Church, chr: shared Church) : shared Church {
    return new shared ComposeChurch(chl, chr): shared Church;
}

class ConstChurch : Church {
    const ch: shared Church;
    override proc this(f: shared Church): shared Church { return ch; }
}

proc constChurch(ch: shared Church): shared Church {
    return new shared ConstChurch(ch): shared Church;
}

// Church constants...
const cIdentityChurch: shared Church = new shared Church();
const cChurchZero = constChurch(cIdentityChurch);
const cChurchOne = cIdentityChurch; // default is identity!

// Church functions...
class SuccChurch: Church {
    const curr: shared Church;
    override proc this(f: shared Church): shared Church {
        return composeChurch(f, curr(f)); }
}

proc succChurch(ch: shared Church): shared Church {
    return new shared SuccChurch(ch) : shared Church;
}

class AddChurch: Church {
    const chf, chs: shared Church;
    override proc this(f: shared Church): shared Church {
        return composeChurch(chf(f), chs(f)); }
}

proc addChurch(cha: shared Church, chb: shared Church): shared Church {
    return new shared AddChurch(cha, chb) : shared Church;
}

class MultChurch: Church {
    const chf, chs: shared Church;
    override proc this(f: shared Church): shared Church {
        return composeChurch(chf, chs)(f); }
}

proc multChurch(cha: shared Church, chb: shared Church): shared Church {
    return new shared MultChurch(cha, chb) : shared Church;
}

class ExpChurch : Church {
    const b, e : shared Church;
    override proc this(f : shared Church): shared Church { return e(b)(f); }
}

proc expChurch(chbs: shared Church, chexp: shared Church): shared Church {
    return new shared ExpChurch(chbs, chexp) : shared Church;
}

class IsZeroChurch : Church {
    const c : shared Church;
    override proc this(f : shared Church): shared Church {
        return c(constChurch(cChurchZero))(cChurchOne)(f); }
}

proc isZeroChurch(ch: shared Church): shared Church {
    return new shared IsZeroChurch(ch) : shared Church;
}

class PredChurch : Church {
    const c : shared Church;
    class XFunc : Church {
        const cf, fnc: shared Church;
        class GFunc : Church {
            const fnc: shared Church;
            class HFunc : Church {
                const fnc, g: shared Church;
                override proc this(f : shared Church): shared Church {
                    return f(g(fnc)); }
            }
            override proc this(f : shared Church): shared Church {
                return new shared HFunc(fnc, f): shared Church; }
        }
        override proc this(f : shared Church): shared Church {
            const prd = new shared GFunc(fnc): shared Church;
            return cf(prd)(constChurch(f))(cIdentityChurch); }
    }
    override proc this(f : shared Church): shared Church {
        return new shared XFunc(c, f) : shared Church; }
}

proc predChurch(ch: shared Church): shared Church {
    return new shared PredChurch(ch) : shared Church;
}

class SubChurch : Church {
    const a, b : shared Church;
    class PredFunc : Church {
        override proc this(f : shared Church): shared Church {
            return new shared PredChurch(f): shared Church;
        }
    }
    override proc this(f : shared Church): shared Church {
        const prdf = new shared PredFunc(): shared Church;
        return b(prdf)(a)(f); }
}

proc subChurch(cha: shared Church, chb: shared Church): shared Church {
    return new shared SubChurch(cha, chb) : shared Church;
}

class DivrChurch : Church {
    const v, d : shared Church;
    override proc this(f : shared Church): shared Church {
        const loopr = constChurch(succChurch(divr(v, d)));
        return v(loopr)(cChurchZero)(f); }
}

proc divr(n: shared Church, d : shared Church): shared Church {
    return new shared DivrChurch(subChurch(n, d), d): shared Church;
}

proc divChurch(chdvdnd: shared Church, chdvsr: shared Church): shared Church {
    return divr(succChurch(chdvdnd), chdvsr);
}

// conversion functions...
proc loopChurch(i: int, ch: shared Church) : shared Church { // tail call...
    return if (i <= 0) then ch else loopChurch(i - 1, succChurch(ch));
}

proc churchFromInt(n: int): shared Church {
    return loopChurch(n, cChurchZero); // can't embed "worker" proc!
}

class IntChurch : Church {
    const value: int;
}

class IncChurch : Church {
    override proc this(f: shared Church): shared Church {
        const tst = f: IntChurch;
        if tst != nil {
          return new shared IntChurch(tst.value + 1): shared Church; }
        else return f; } // shouldn't happen!
}

proc intFromChurch(ch: shared Church): int {
    const zero = new shared IntChurch(0): shared Church;
    const tst = ch(new shared IncChurch(): shared Church)(zero): IntChurch;
    if tst != nil { return tst.value; }
    else return -1; // should never happen!
}

// testing...
const ch3 = churchFromInt(3); const ch4 = succChurch(ch3);
const ch11 = churchFromInt(11); const ch12 = succChurch(ch11);
write(intFromChurch(addChurch(ch3, ch4)), ", ");
write(intFromChurch(multChurch(ch3, ch4)), ", ");
write(intFromChurch(expChurch(ch3, ch4)), ", ");
write(intFromChurch(expChurch(ch4, ch3)), ", ");
write(intFromChurch(isZeroChurch(cChurchZero)), ", ");
write(intFromChurch(isZeroChurch(ch3)), ", ");
write(intFromChurch(predChurch(ch4)), ", ");
write(intFromChurch(predChurch(cChurchZero)), ", ");
write(intFromChurch(subChurch(ch11, ch3)), ", ");
write(intFromChurch(divChurch(ch11, ch3)), ", ");
writeln(intFromChurch(divChurch(ch12, ch3)));

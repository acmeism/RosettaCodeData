#!/usr/bin/awk -f

BEGIN {
    initStack()
    initOpers()
    print "Infix: " toInfix("3 4 2 * 1 5 - 2 3 ^ ^ / +")
    print ""
    print "Infix: " toInfix("1 2 + 3 4 + ^ 5 6 + ^")
    print ""
    print "Infix: " toInfix("moon stars mud + * fire soup * ^")
    exit
}

function initStack() {
    delete stack
    stackPtr = 0
}

function initOpers() {
    VALPREC = "9"
    LEFT = "l"
    RIGHT = "r"
    operToks  = "+"  "-"  "/"  "*"  "^"
    operPrec  = "2"  "2"  "3"  "3"  "4"
    operAssoc = LEFT LEFT LEFT LEFT RIGHT
}

function toInfix(rpn,      t, toks, tok, a, ap, b, bp, tp, ta) {
    print "Postfix: " rpn
    split(rpn, toks, / +/)
    for (t = 1; t <= length(toks); t++) {
        tok = toks[t]
        if (!isOper(tok)) {
            push(VALPREC tok)
        }
         else {
            b = pop()
            bp = prec(b)
            b = tail(b)
            a = pop()
            ap = prec(a)
            a = tail(a)
            tp = tokPrec(tok)
            ta = tokAssoc(tok)
            if (ap < tp || (ap == tp && ta == RIGHT)) {
                a = "(" a ")"
            }
            if (bp < tp || (bp == tp && ta == LEFT)) {
                b = "(" b ")"
            }
            push(tp a " "  tok " " b)
        }
        print "    " tok " -> " stackToStr()
    }
    return tail(pop())
}

function push(expr) {
    stack[stackPtr] = expr
    stackPtr++
}

function pop() {
    stackPtr--
    return stack[stackPtr]
}

function isOper(tok) {
    return index(operToks, tok) != 0
}

function prec(expr) {
    return substr(expr, 1, 1)
}

function tokPrec(tok) {
    return substr(operPrec, operIdx(tok), 1)
}

function tokAssoc(tok) {
    return substr(operAssoc, operIdx(tok), 1)
}

function operIdx(tok) {
    return index(operToks, tok)
}

function tail(s) {
    return substr(s, 2)
}

function stackToStr(    s, i, t, p) {
    s = ""
    for (i = 0; i < stackPtr; i++) {
        t = stack[i]
        p = prec(t)
        if (index(t, " ")) t = "{" tail(t) "}"
        else t = tail(t)
        s = s "{" p " " t "} "
    }
    return s
}

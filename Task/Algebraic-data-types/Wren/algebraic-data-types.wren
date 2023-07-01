var R = "R"
var B = "B"

class Tree {
    ins(x) {}    // overridden by child classes

    insert(x) {  // inherited by child classes
        var t = ins(x)
        if (t.type == T) return T.new(B, t.le, t.aa, t.ri)
        if (t.type == E) return E.new()
        return null
    }
}

class T is Tree {
    construct new(cl, le, aa, ri) {
        _cl = cl  // color
        _le = le  // Tree
        _aa = aa  // integer
        _ri = ri  // Tree
    }

    cl { _cl }
    le { _le }
    aa { _aa }
    ri { _ri }

    balance() {
        if (_cl != B) return this

        var le2 = _le.type == T ? _le : null
        var lele
        var leri
        if (le2) {
            lele = _le.le.type == T ? _le.le : null
            leri = _le.ri.type == T ? _le.ri : null
        }
        var ri2 = _ri.type == T ? _ri : null
        var rile
        var riri
        if (ri2) {
            rile = _ri.le.type == T ? _ri.le : null
            riri = _ri.ri.type == T ? _ri.ri : null
        }

        if (le2 && lele && le2.cl == R && lele.cl == R) {
            var t = le2.le
            return T.new(R, T.new(B, t.le, t.aa, t.ri), le2.aa, T.new(B, le2.ri, _aa, _ri))
        }
        if (le2 && leri && le2.cl == R && leri.cl == R) {
            var t = le2.ri
            return T.new(R, T.new(B, le2.le, le2.aa, t.le), t.aa, T.new(B, t.ri, _aa, _ri))
        }
        if (ri2 && rile && ri2.cl == R && rile.cl == R) {
            var t = ri2.ri
            return T.new(R, T.new(B, _le, _aa, t.le), t.aa, T.new(B, t.ri, ri2.aa, ri2.ri))
        }
        if (ri2 && riri && ri2.cl == R && riri.cl == R) {
            var t = ri2.ri
            return T.new(R, T.new(B, _le, _aa, ri2.le), ri2.aa, T.new(B, t.le, t.aa, t.ri))
        }
        return this
    }

    ins(x) {
        if (x < _aa) return T.new(_cl, _le.ins(x), _aa, _ri).balance()
        if (x > _aa) return T.new(_cl, _le, _aa, _ri.ins(x)).balance()
        return this
    }

    toString { "T(%(_cl), %(_le), %(_aa), %(_ri))" }
}

class E is Tree {
    construct new() {}

    ins(x) { T.new(R, E.new(), x, E.new()) }

    toString { "E" }
}

var tr = E.new()
for (i in 1..16) tr = tr.insert(i)
System.print(tr)

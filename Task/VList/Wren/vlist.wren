class VSeg_ {
    construct new() {
        _next = null
        _ele  = []
    }

    next       { _next }
    next=(n)   { _next = n}
    ele        { _ele }
    ele=(e)    { _ele = e }
}

class VList {
    construct new() {
        _base = null
        _offset = 0
    }

    base       { _base }
    base=(b)   { _base = b}
    offset     { _offset }
    offset=(o) { _offset = o }

    /* locate kth element */
    [k] {
        var i = k
        if (i >= 0) {
            i = i + _offset
            var sg = _base
            while (sg) {
                if (i < sg.ele.count) return sg.ele[i]
                i = i - sg.ele.count
                sg = sg.next
            }
        }
        Fiber.abort("Index out of range.")
    }

    /* add an element to the front of VList */
    cons(a) {
        if (!_base) {
            var v = VList.new()
            var s = VSeg_.new()
            s.ele = [a]
            v.base = s
            return v
        }
        if (_offset == 0) {
            var l2 = _base.ele.count * 2
            var ele = List.filled(l2, null)
            ele[l2 - 1] = a
            var v = VList.new()
            var s = VSeg_.new()
            s.next = _base
            s.ele = ele
            v.base = s
            v.offset = l2 - 1
            return v
        }
        _offset = _offset - 1
        _base.ele[_offset] = a
        return this
    }

    /* obtain a new VList beginning at the second element of an old VList */
    cdr() {
        if (!_base) Fiber.abort("cdr invoked on empty VList")
        _offset = _offset + 1
        if (offset < _base.ele.count) return this
        var v = VList.new()
        v.base = _base.next
        return v
    }

     /* compute the size of the VList */
    size {
        if (!_base) return 0
        return _base.ele.count * 2 - _offset - 1
    }

    toString {
        if (!_base) return "[]"
        var r = "[%(_base.ele[_offset])"
        var sg = _base
        var sl = _base.ele[_offset + 1..-1]
        while (true) {
            for (e in sl) r = r + " %(e)"
            sg = sg.next
            if (!sg) break
            sl = sg.ele
        }
        return r + "]"
    }

    printStructure() {
        System.print("Offset: %(_offset)")
        var sg = _base
        while (sg) {
            System.print(sg.ele)
            sg = sg.next
        }
        System.print()
    }
}

var v = VList.new()
System.print("Before adding any elements, empty VList: %(v)")
v.printStructure()

for (a in 6..1) v = v.cons(a)
System.print("Demonstrating cons method, 6 elements added: %(v)")
v.printStructure()

v = v.cdr()
System.print("Demonstrating cdr method, 1 element removed: %(v)")
v.printStructure()

System.print("Demonstrating size property, size = %(v.size)\n")
System.print("Demonstrating element access, v[3] = %(v[3])\n")

v = v.cdr().cdr()
System.print("Demonstrating cdr method again, 2 more elements removed: %(v)")
v.printStructure()

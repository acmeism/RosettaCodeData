struct Set(T) {
    const pure nothrow bool delegate(in T) contains;

    bool opIn_r(in T x) const pure nothrow {
        return contains(x);
    }

    Set opBinary(string op)(in Set set)
    const pure nothrow if (op == "+" || op == "-") {
        static if (op == "+")
            return Set(x => contains(x) || set.contains(x));
        else
            return Set(x => contains(x) && !set.contains(x));
    }

    Set intersection(in Set set) const pure nothrow {
        return Set(x => contains(x) && set.contains(x));
    }
}

unittest { // Test union.
    alias DSet = Set!double;
    const s = DSet(x => 0.0 < x && x <= 1.0) +
              DSet(x => 0.0 <= x && x < 2.0);
    assert(0.0 in s);
    assert(1.0 in s);
    assert(2.0 !in s);
}

unittest { // Test difference.
    alias DSet = Set!double;
    const s1 = DSet(x => 0.0 <= x && x < 3.0) -
               DSet(x => 0.0 < x && x < 1.0);
    assert(0.0 in s1);
    assert(0.5 !in s1);
    assert(1.0 in s1);
    assert(2.0 in s1);

    const s2 = DSet(x => 0.0 <= x && x < 3.0) -
               DSet(x => 0.0 <= x && x <= 1.0);
    assert(0.0 !in s2);
    assert(1.0 !in s2);
    assert(2.0 in s2);

    const s3 = DSet(x => 0 <= x && x <= double.infinity) -
               DSet(x => 1.0 <= x && x <= 2.0);
    assert(0.0 in s3);
    assert(1.5 !in s3);
    assert(3.0 in s3);
}

unittest { // Test intersection.
    alias DSet = Set!double;
    const s = DSet(x => 0.0 <= x && x < 2.0).intersection(
              DSet(x => 1.0 < x && x <= 2.0));
    assert(0.0 !in s);
    assert(1.0 !in s);
    assert(2.0 !in s);
}

void main() {}

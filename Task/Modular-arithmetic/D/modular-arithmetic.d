import std.stdio;

version(unittest) {
    void assertEquals(T)(T actual, T expected) {
        import core.exception;
        import std.conv;
        if (actual != expected) {
            throw new AssertError("Actual [" ~ to!string(actual) ~ "]; Expected [" ~ to!string(expected) ~ "]");
        }
    }
}

void main() {
    auto input = ModularInteger(10,13);
    auto output = f(input);
    writeln("f(", input, ") = ", output);
}

V f(V)(const V x) {
    return x^^100 + x + 1;
}

/// Integer tests on f
unittest {
    assertEquals(f(1), 3);
    assertEquals(f(0), 1);
}

/// Floating tests on f
unittest {
    assertEquals(f(1.0), 3.0);
    assertEquals(f(0.0), 1.0);
}

struct ModularInteger {
    private:
    int value;
    int modulus;

    public:
    this(int value, int modulus) {
        this.modulus = modulus;
        this.value = value % modulus;
    }

    ModularInteger opBinary(string op : "+")(ModularInteger rhs) const in {
        assert(this.modulus == rhs.modulus);
    } body {
        return ModularInteger((this.value + rhs.value) % this.modulus, this.modulus);
    }

    ModularInteger opBinary(string op : "+")(int rhs) const {
        return ModularInteger((this.value + rhs) % this.modulus, this.modulus);
    }

    ModularInteger opBinary(string op : "*")(ModularInteger rhs) const in {
        assert(this.modulus == rhs.modulus);
        assert(this.value < this.modulus);
        assert(rhs.value < this.modulus);
    } body {
        return ModularInteger((this.value * rhs.value) % this.modulus, this.modulus);
    }

    ModularInteger opBinary(string op : "^^")(int pow) const in {
        assert(pow >= 0);
    } body {
        auto base = ModularInteger(1, this.modulus);
        while (pow-- > 0) {
            base = base * this;
        }
        return base;
    }

    string toString() {
        import std.format;
        return format("ModularInteger(%s, %s)", value, modulus);
    }
}

/// Addition with same type of int
unittest {
    auto a = ModularInteger(2,5);
    auto b = ModularInteger(3,5);
    assertEquals(a+b, ModularInteger(0,5));
}

/// Addition with differnt int types
unittest {
    auto a = ModularInteger(2,5);
    assertEquals(a+0, a);
    assertEquals(a+1, ModularInteger(3,5));
}

/// Muliplication
unittest {
    auto a = ModularInteger(2,5);
    auto b = ModularInteger(3,5);
    assertEquals(a*b, ModularInteger(1,5));
}

/// Power
unittest {
    const a = ModularInteger(3,13);
    assertEquals(a^^2, ModularInteger(9,13));
    assertEquals(a^^3, ModularInteger(1,13));

    const b = ModularInteger(10,13);
    assertEquals(b^^1, ModularInteger(10,13));
    assertEquals(b^^2, ModularInteger(9,13));
    assertEquals(b^^3, ModularInteger(12,13));
    assertEquals(b^^4, ModularInteger(3,13));
    assertEquals(b^^5, ModularInteger(4,13));
    assertEquals(b^^6, ModularInteger(1,13));
    assertEquals(b^^7, ModularInteger(10,13));
    assertEquals(b^^8, ModularInteger(9,13));
    assertEquals(b^^10, ModularInteger(3,13));
    assertEquals(b^^20, ModularInteger(9,13));
    assertEquals(b^^30, ModularInteger(1,13));
    assertEquals(b^^50, ModularInteger(9,13));
    assertEquals(b^^75, ModularInteger(12,13));
    assertEquals(b^^90, ModularInteger(1,13));
    assertEquals(b^^95, ModularInteger(4,13));
    assertEquals(b^^97, ModularInteger(10,13));
    assertEquals(b^^98, ModularInteger(9,13));
    assertEquals(b^^99, ModularInteger(12,13));
    assertEquals(b^^100, ModularInteger(3,13));
}

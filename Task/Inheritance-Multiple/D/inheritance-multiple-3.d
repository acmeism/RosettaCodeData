class A {
    string foo() {
        return "I am an A.";
    }
}
class B {
    string foo() {
        return "I am a B.";
    }
}

class C : A {
    string className = "C";
    override string foo() {
        return "I am a "~className~", and thus an A.";
    }
    @property
    BWrapper asB() {
        return new BWrapper();
    }
    alias asB this;
    class BWrapper : B {
        override string foo() {
            return "I am a "~className~", disguised as a B.";
        }
    }
}

unittest {
    import std.stdio : writeln;

    auto c = new C();
    A a = c;
    B b = c;

    writeln(a.foo());
    writeln(b.foo());
}

class Delegator {
    string delegate() hasDelegate;

    string operation() {
        if (hasDelegate is null)
            return "Default implementation";
        return hasDelegate();
    }

    typeof(this) setDg(string delegate() dg) {
        hasDelegate = dg;
        return this;
    }
}

void main() {
    import std.stdio;
    auto dr = new Delegator;
    string delegate() thing = () => "Delegate implementation";

    writeln(dr.operation());
    writeln(dr.operation());
    writeln(dr.setDg(thing).operation());
}

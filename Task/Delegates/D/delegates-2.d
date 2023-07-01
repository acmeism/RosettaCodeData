import tango.io.Stdout;

class Delegator
{
    private char[] delegate() hasDelegate;
public:
    char[] operation() {
        if (hasDelegate is null)
            return "default implementation";
        return hasDelegate();
    }

    typeof(this) setDg(char[] delegate() dg)
    {
        hasDelegate = dg;
        return this;
    }
}

int main(char[][] args)
{
    auto dr = new Delegator();
    auto thing = delegate char[]() { return "delegate implementation"; };

    Stdout ( dr.operation ).newline;
    Stdout ( dr.operation ).newline;
    Stdout ( dr.setDg(thing).operation ).newline;
    return 0;
}

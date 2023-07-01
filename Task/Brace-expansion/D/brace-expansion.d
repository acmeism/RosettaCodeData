import std.stdio, std.typecons, std.array, std.range, std.algorithm, std.string;

Nullable!(Tuple!(string[], string)) getGroup(string s, in uint depth)
pure nothrow @safe {
    string[] sout;
    auto comma = false;

    while (!s.empty) {
        // {const g, s} = getItems(s, depth);
        const r = getItems(s, depth);
        const g = r[0];
        s = r[1];

        if (s.empty)
            break;
        sout ~= g;

        if (s[0] == '}') {
            if (comma)
                return typeof(return)(tuple(sout, s[1 .. $]));
            return typeof(return)(tuple(
                sout.map!(a => '{' ~ a ~ '}').array, s[1 .. $]));
        }

        if (s[0] == ',') {
            comma = true;
            s = s[1 .. $];
        }
    }
    return typeof(return)();
}

Tuple!(string[], string) getItems(string s, in uint depth=0) pure @safe nothrow {
    auto sout = [""];

    while (!s.empty) {
        auto c = s[0 .. 1];
        if (depth && (c == "," || c == "}"))
            return tuple(sout, s);

        if (c == "{") {
            /*const*/ auto x = getGroup(s.dropOne, depth + 1);
            if (!x.isNull) {
                sout = cartesianProduct(sout, x[0])
                       .map!(ab => ab[0] ~ ab[1])
                       .array;
                s = x[1];
                continue;
            }
        }

        if (c == "\\" && s.length > 1) {
            c ~= s[1];
            s = s[1 .. $];
        }

        sout = sout.map!(a => a ~ c).array;
        s = s[1 .. $];
    }
    return tuple(sout, s);
}

void main() @safe {
    immutable testCases = r"~/{Downloads,Pictures}/*.{jpg,gif,png}
It{{em,alic}iz,erat}e{d,}, please.
{,{,gotta have{ ,\, again\, }}more }cowbell!
{}} some }{,{\\{ edge, edge} \,}{ cases, {here} \\\\\}
a{b{1,2}c
a{1,2}b}c
a{1,{2},3}b
a{b{1,2}c{}}
more{ darn{ cowbell,},}
ab{c,d\,e{f,g\h},i\,j{k,l\,m}n,o\,p}qr
{a,{\,b}c
a{b,{{c}}
{a{\}b,c}d
{a,b{{1,2}e}f";

    foreach (const s; testCases.splitLines)
        writefln("%s\n%-(    %s\n%)\n", s, s.getItems[0]);
}

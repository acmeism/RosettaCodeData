import std.stdio, std.regex, std.range;

auto commatize(in char[] txt, in uint start=0, in uint step=3,
        in string ins=",") @safe
in {
    assert(step > 0);
} body {
    if (start > txt.length || step > txt.length)
        return txt;

    // First number may begin with digit or decimal point. Exponents ignored.
    enum decFloField = ctRegex!("[0-9]*\\.[0-9]+|[0-9]+");

    auto matchDec = matchFirst(txt[start .. $], decFloField);
    if (!matchDec)
        return txt;

    // Within a decimal float field:
    // A decimal integer field to commatize is positive and not after a point.
    enum decIntField = ctRegex!("(?<=\\.)|[1-9][0-9]*");
    // A decimal fractional field is preceded by a point, and is only digits.
    enum decFracField = ctRegex!("(?<=\\.)[0-9]+");

    return txt[0 .. start] ~ matchDec.pre ~ matchDec.hit
        .replace!(m => m.hit.retro.chunks(step).join(ins).retro)(decIntField)
        .replace!(m => m.hit.chunks(step).join(ins))(decFracField)
        ~ matchDec.post;
}

unittest {
    // An attempted solution may have one or more of the following errors:
    //    ignoring a number that has only zero before its decimal point
    assert("0.0123456".commatize == "0.012,345,6");
    //    commatizing numbers other than the first
    assert("1000 2.3000".commatize == "1,000 2.3000");
    //    only commatizing in one direction from the decimal point
    assert("0001123.456789".commatize == "0001,123.456,789");
    //    detecting prefixes such as "Z$" requires detecting other prefixes
    assert(" NZ$300000".commatize == " NZ$300,000");
    //    detecting a decimal field that isn't attached to the first number
    assert(" 2600 and .0125".commatize == " 2,600 and .0125");
    //    ignoring the start value, or confusing base 0 (used here) with base 1
    assert("1 77000".commatize(1) == "1 77,000");
    //    ignoring a number that begins with a point, or treating it as integer
    assert(" .0104004".commatize == " .010,400,4");
}

void main() {
    "pi=3.14159265358979323846264338327950288419716939937510582097494459231"
        .commatize(0, 5, " ").writeln;
    "The author has two Z$100000000000000 Zimbabwe notes (100 trillion)."
        .commatize(0, 3, ".").writeln;
    foreach (const line; "commatizing_numbers_using_defaults.txt".File.byLine)
        line.commatize.writeln;
}

import std.stdio;

void main() {
    auto isins = [
        "US0378331005",
        "US0373831005",
        "U50378331005",
        "US03378331005",
        "AU0000XVGZA3",
        "AU0000VXGZA3",
        "FR0000988040",
    ];
    foreach (isin; isins) {
        writeln(isin, " is ", ISINvalidate(isin) ? "valid" : "not valid");
    }
}

bool ISINvalidate(string isin) {
    import std.array : appender;
    import std.conv : to;
    import std.regex : matchFirst;
    import std.string : strip, toUpper;

    isin = isin.strip.toUpper;

    if (isin.matchFirst(`^[A-Z]{2}[A-Z0-9]{9}\d$`).empty) {
        return false;
    }

    auto sb = appender!string;
    foreach (c; isin[0..12]) {
        sb.put(
            [c].to!int(36)
               .to!string
        );
    }

    import luhn;
    return luhnTest(sb.data);
}

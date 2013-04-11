import std.stdio, std.array, std.algorithm;

string[] multiSplit(in string s, in string[] divisors)
/*pure nothrow*/ {
    string[] result;
    auto rest = s.idup;

    while (true) {
	    bool done = true;
        string delim;
        {
            string best;
            foreach (div; divisors) {
                const maybe = find(rest, div);
                if (maybe.length > best.length) {
                    best = maybe;
                    delim = div;
                    done = false;
                }
            }
        }
	    result.length++;
	    if (done) {
		    result[$ - 1] = rest.idup;
		    return result;
	    } else {
		    const t = findSplit(rest, delim);
		    result[$ - 1] = t[0].idup;
		    rest = t[2];
	    }
    }
}

void main() {
    immutable s = "a!===b=!=c";
    immutable divs = ["==", "!=", "="];
    writeln(multiSplit(s, divs).join(" {} "));
}

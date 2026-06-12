import std.algorithm;
import std.stdio;

string lcs(string[] a) {
    auto le = a.length;
    if (le == 0) {
        return "";
    }
    if (le == 1) {
        return a[0];
    }
    auto le0 = a[0].length;
    auto minLen = a.map!"a.length".reduce!"min(a,b)";
    if (minLen == 0) {
        return "";
    }
    auto res = "";
    foreach (i; 1..minLen) {
        auto suffix = a[0][le0 - i .. $];
        foreach (e; a[1..$]) {
            if (!e.endsWith(suffix)) {
                return res;
            }
        }
        res = suffix;
    }
    return "";
}

void main() {
    auto tests = [
        ["baabababc", "baabc", "bbbabc"],
        ["baabababc", "baabc", "bbbazc"],
        ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"],
        ["longest", "common", "suffix"],
        ["suffix"],
        [""]
    ];
    foreach (test; tests) {
        writeln(test, " -> `", lcs(test), '`');
    }
}

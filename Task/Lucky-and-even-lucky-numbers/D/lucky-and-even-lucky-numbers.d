import std.algorithm;
import std.concurrency;
import std.conv;
import std.getopt;
import std.range;
import std.stdio;

auto lucky(bool even, int nmax=200_000) {
    import std.container.array;

    int start = even ? 2 : 1;

    return new Generator!int({
        auto ln = make!(Array!int)(iota(start,nmax,2));

        // yield the first number
        yield(ln[0]);

        int n=1;
        for(; n<ln.length/2+1; n++) {
            yield(ln[n]);

            int step = ln[n]-1;

            // remove the non-lucky numbers related to the current lucky number
            for (int i=step; i<ln.length; i+=step) {
                ln.linearRemove(ln[].drop(i).take(1));
            }
        }

        // yield all remaining values
        foreach(val; ln[n..$]) {
            yield(val);
        }
    });
}

void help(Option[] opt) {
    defaultGetoptPrinter("./lucky j [k] [--lucky|--evenLucky]", opt);

    writeln;
    writeln("       argument(s)        |  what is displayed");
    writeln("==============================================");
    writeln("-j=m                      |  mth lucky number");
    writeln("-j=m  --lucky             |  mth lucky number");
    writeln("-j=m  --evenLucky         |  mth even lucky number");
    writeln("-j=m  -k=n                |  mth through nth (inclusive) lucky numbers");
    writeln("-j=m  -k=n  --lucky       |  mth through nth (inclusive) lucky numbers");
    writeln("-j=m  -k=n  --evenLucky   |  mth through nth (inclusive) even lucky numbers");
    writeln("-j=m  -k=-n               |  all lucky numbers in the range [m, n]");
    writeln("-j=m  -k=-n  --lucky      |  all lucky numbers in the range [m, n]");
    writeln("-j=m  -k=-n  --evenLucky  |  all even lucky numbers in the range [m, n]");
}

void main(string[] args) {
    int j;
    int k;
    bool evenLucky = false;

    void luckyOpt() {
        evenLucky = false;
    }
    auto helpInformation = getopt(
        args,
        std.getopt.config.passThrough,
        std.getopt.config.required,
        "j", "The starting point to generate lucky numbers", &j,
        "k", "The ending point for generating lucky numbers", &k,
        "lucky", "Specify to generate a list of lucky numbers", &luckyOpt,
        "evenLucky", "Specify to generate a list of even lucky numbers", &evenLucky
    );

    if (helpInformation.helpWanted) {
        help(helpInformation.options);
        return;
    }

    if (k>0) {
        lucky(evenLucky).drop(j-1).take(k-j+1).writeln;
    } else if (k<0) {
        auto f = (int a) => j<=a && a<=-k;
        lucky(evenLucky, -k).filter!f.writeln;
    } else {
        lucky(evenLucky).drop(j-1).take(1).writeln;
    }
}

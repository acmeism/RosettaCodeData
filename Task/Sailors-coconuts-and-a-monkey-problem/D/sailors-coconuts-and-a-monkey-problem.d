import std.stdio;

void main() {
    auto coconuts = 11;

    outer:
    foreach (ns; 2..10) {
        int[] hidden = new int[ns];
        coconuts = (coconuts / ns) * ns + 1;
        while (true) {
            auto nc = coconuts;
            foreach (s; 1..ns+1) {
                if (nc % ns == 1) {
                    hidden[s-1] = nc/ns;
                    nc -= hidden[s-1] + 1;
                    if (s==ns && nc%ns==0) {
                        writeln(ns, " sailors require a minimum of ", coconuts, " coconuts");
                        foreach (t; 1..ns+1) {
                            writeln("\tSailor ", t, " hides ", hidden[t - 1]);
                        }
                        writeln("\tThe monkey gets ", ns);
                        writeln("\tFinally, each sailor takes ", nc / ns);
                        continue outer;
                    }
                } else {
                    break;
                }
            }
            coconuts += ns;
        }
    }
}

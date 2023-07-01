import std.stdio;

void main() {
    fourSquare(1,7,true,true);
    fourSquare(3,9,true,true);
    fourSquare(0,9,false,false);
}

void fourSquare(int low, int high, bool unique, bool print) {
    int count;

    if (print) {
        writeln("a b c d e f g");
    }
    for (int a=low; a<=high; ++a) {
        for (int b=low; b<=high; ++b) {
            if (!valid(unique, a, b)) continue;

            int fp = a+b;
            for (int c=low; c<=high; ++c) {
                if (!valid(unique, c, a, b)) continue;
                for (int d=low; d<=high; ++d) {
                    if (!valid(unique, d, a, b, c)) continue;
                    if (fp != b+c+d) continue;

                    for (int e=low; e<=high; ++e) {
                        if (!valid(unique, e, a, b, c, d)) continue;
                        for (int f=low; f<=high; ++f) {
                            if (!valid(unique, f, a, b, c, d, e)) continue;
                            if (fp != d+e+f) continue;

                            for (int g=low; g<=high; ++g) {
                                if (!valid(unique, g, a, b, c, d, e, f)) continue;
                                if (fp != f+g) continue;

                                ++count;
                                if (print) {
                                    writeln(a,' ',b,' ',c,' ',d,' ',e,' ',f,' ',g);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    if (unique) {
        writeln("There are ", count, " unique solutions in [",low,",",high,"]");
    } else {
        writeln("There are ", count, " non-unique solutions in [",low,",",high,"]");
    }
}

bool valid(bool unique, int needle, int[] haystack ...) {
    if (unique) {
        foreach (value; haystack) {
            if (needle == value) {
                return false;
            }
        }
    }
    return true;
}

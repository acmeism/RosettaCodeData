import std.stdio, std.range;

void main() {
    int sol = 1;
    writeln("\t\tFIRE\t\tPOLICE\t\tSANITATION");
    foreach( f; iota(1,8) ) {
        foreach( p; iota(1,8) ) {
            foreach( s; iota(1,8) ) {
                if( f != p && f != s && p != s && !( p & 1 ) && ( f + s + p == 12 ) ) {
                    writefln("SOLUTION #%2d:\t%2d\t\t%3d\t\t%6d", sol++, f, p, s);
                }
            }
        }
    }
}

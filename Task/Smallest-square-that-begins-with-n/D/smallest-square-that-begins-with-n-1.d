import std.stdio;
import std.range;

void f(int n) {
    if (n < 1) {
        return;
    }

    int i = 1;

    while (true) {
        int sq = i * i;

        while (sq > n) {
            sq /= 10;
        }
        if (sq == n) {
 			"%3d %9d %4d".writefln(n, i * i, i);
			
            return;
        }

        i++;
     }
}

void main()
{
	"Prefix    n^2    n".writeln;

	foreach(i ; iota(1, 50))
	{
		f(i);
	}
	
}

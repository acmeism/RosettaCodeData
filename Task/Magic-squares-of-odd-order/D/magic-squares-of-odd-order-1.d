void main(in string[] args)
{
    import std.stdio, std.conv, std.range, std.algorithm, std.exception;

    immutable n = args.length == 2 ? args[1].to!uint : 5;
    enforce(n > 0 && n % 2 == 1, "Only odd n > 1");
    immutable len = text(n ^^ 2).length.text;
   // writeln(len);

    foreach (immutable r; 1 .. n + 1)
    {
        foreach (immutable c; 1 .. n + 1)
        {
            auto a = (n * ((r + c - 1 + (n / 2)) % n)) + ((r + (2 * c) - 2) % n) + 1;
            // n(( I + J - 1 + ( n / 2 ) ) mod n ) + (( I + 2J - 2 ) mod n ) + 1
//        writeln("n = ",n, " r = ",r," c = ",c, " a = ",a );
          writef("%" ~ len ~ "d%s",a, " ");
        }
        writeln("");
    }
    ;

    writeln("\nMagic constant: ", ((n * n + 1) * n) / 2);
}}

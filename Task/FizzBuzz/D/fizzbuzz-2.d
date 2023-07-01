import std;

void main()
{
    auto fizzbuzz(in uint i)
    {
        string r;
        if (i % 3 == 0) r ~= "fizz";
        if (i % 5 == 0) r ~= "buzz";
        if (r.length == 0) r ~= i.to!string;
        return r;
    }

    enum r = 1.iota(101).map!fizzbuzz;

    r.each!writeln;
}

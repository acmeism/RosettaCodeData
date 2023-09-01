import std.stdio;
import std.conv;
import std.algorithm;
import std.range;

bool isOwnDigitsPowerSum(uint n)
{
    auto nStr = n.text;
    return nStr.map!(d => (d - '0') ^^ nStr.length).sum == n;
}

void main()
{
    iota(10^^2, 10^^9).filter!isOwnDigitsPowerSum.writeln;
}

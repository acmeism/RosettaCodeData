import std.stdio, std.array, std.algorithm;

void main()
{
    int target = 988;
    auto coins = [200, 100, 50, 20, 10, 5, 2, 1];	

    auto result = coins
                    .map!((coin) {
                        auto numCoins = target / coin;
                        target -= numCoins * coin;
                        return [numCoins, coin];
                    })
                    .array;

    auto numOfCoins = result
                        .map!(t => t[0])
                        .sum;

    auto checkSum = result
                        .map!(t => t[0] * t[1])
                        .sum;

    "\n%d coins to make: %d\n".writefln(numOfCoins, checkSum);
    result.each!(t => "%2d  x %3d".writefln(t[0], t[1]));
}

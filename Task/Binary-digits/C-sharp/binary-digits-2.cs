using System;
using System.Text;

static string ToBinary(uint x) {
    if(x == 0) return "0";
    var bin = new StringBuilder();
    for(uint mask = (uint)1 << (sizeof(uint)*8 - 1);mask > 0;mask = mask >> 1)
        bin.Append((mask & x) > 0 ? "1" : "0");
    return bin.ToString().TrimStart('0');
}

Console.WriteLine(ToBinary(5));
Console.WriteLine(ToBinary(50));
Console.WriteLine(ToBinary(9000));

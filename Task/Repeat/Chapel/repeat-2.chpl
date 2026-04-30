config const n = 5;

proc example()
{
    writeln("example");
}

proc repeat(func : proc(), n : uint)
{
    for i in 0..#n do func();
}

repeat(example, n);

config const n = 5;

proc example()
{
    writeln("example");
}

proc repeat(func, n)
{
    for i in 0..#n do func();
}

repeat(example, n);

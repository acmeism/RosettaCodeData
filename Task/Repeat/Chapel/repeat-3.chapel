config const n = 5;

proc example(x : uint)
{
    writeln("example ", x);
}

proc repeat(func : proc(x : uint), n : uint)
{
    for i in 0..#n do func(i);
}

repeat(example, n);

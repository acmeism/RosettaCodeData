mixed first = 5;
mixed second = "foo";
array pair = ({ 5, "foo" });

void swapvars(string a, string b)
{
    [this[a], this[b]] = ({ this[b], this[a] });
}

void swaparray(array swapit)
{
    [swapit[1], swapit[0]] = ({ swapit[0], swapit[1] });
}

void main()
{
    write("swap variables:\n");
    write("%O, %O\n", first, second);
    // we could just use [first, second] = ({ second, first });
    swapvars("first", "second");
    write("%O, %O\n", first, second);

    write("swap array:\n");
    write("%{ %O %}\n", pair);
    // we could just use [pair[1], pair[0]] = ({ pair[0], pair[1] });
    // directly, but since arrays are called by reference,
    // it also works through a function
    swaparray(pair);
    write("%{%O %}\n", pair);
}

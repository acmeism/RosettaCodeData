shared void run() {
    "Lazily flatten nested streams"
    {Anything*} flatten({Anything*} stream)
        =>  stream.flatMap((element)
            =>  switch (element)
                case (is {Anything*}) flatten(element)
                else [element]);

    value list = [[1], 2, [[3,4], 5], [[[]]], [[[6]]], 7, 8, []];

    print(list);
    print(flatten(list).sequence());
}

string MakeList(string separator)
{
    int counter = 1;

    Func<string, string> makeItem = item => counter++ + separator + item + "\n";

    return makeItem("first") + makeItem("second") + makeItem("third");
}

Console.WriteLine(MakeList(". "));

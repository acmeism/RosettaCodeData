string MakeList2(string separator)
{
    int counter = 1;

    return MakeItem("first") + MakeItem("second") + MakeItem("third");
    //using string interpolation
    string MakeItem(string item) => $"{counter++}{separator}{item}\n";
}

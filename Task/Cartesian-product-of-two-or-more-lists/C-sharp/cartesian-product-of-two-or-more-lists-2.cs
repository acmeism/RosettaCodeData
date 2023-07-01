public static void Main()
{
    ///...
    var cart1 =
        from a in list1
        from b in list2
        select (a, b); // C# 7.0 tuple
    Console.WriteLine($"{{{string.Join(", ", cart1)}}}");

    var cart2 =
        from a in list7
        from b in list8
        from c in list9
        select (a, b, c);
    Console.WriteLine($"{{{string.Join(", ", cart2)}}}");
}

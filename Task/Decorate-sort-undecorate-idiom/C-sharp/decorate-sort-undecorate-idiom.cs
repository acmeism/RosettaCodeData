public static IEnumerable<T> Schwartzian1<T, TKey>(IEnumerable<T> source, Func<T, TKey> decorator) =>
    source.Select(item => (item, key: decorator(item)))
        .OrderBy(tuple => tuple.key)
        .Select(tuple => tuple.item);

public static IEnumerable<T> Schwartzian2<T, TKey>(IEnumerable<T> source, Func<T, TKey> decorator) =>
    from item in source
    let key = decorator(item)
    orderby key
    select item;

//Call:
string[] array = {"Rosetta", "Code", "is", "a", "programming", "chrestomathy", "site"};
Console.WriteLine(string.Join(" ", Schwartzian1(array, i => i.Length)));

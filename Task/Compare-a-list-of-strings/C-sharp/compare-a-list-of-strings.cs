public static (bool lexicallyEqual, bool strictlyAscending) CompareAListOfStrings(List<string> strings) =>
    strings.Count < 2 ? (true, true) :
    (
        strings.Distinct().Count() < 2,
        Enumerable.Range(1, strings.Count - 1).All(i => string.Compare(strings[i-1], strings[i]) < 0)
    );

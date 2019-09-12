public string ReverseElements(string s)
{
    // In .NET, a text element is series of code units that is displayed as one character, and so reversing the text
    // elements of the string correctly handles combining character sequences and surrogate pairs.
    var elements = System.Globalization.StringInfo.GetTextElementEnumerator(s);
    return string.Concat(AsEnumerable(elements).OfType<string>().Reverse());
}

// Wraps an IEnumerator, allowing it to be used as an IEnumerable.
public IEnumerable AsEnumerable(IEnumerator enumerator)
{
    while (enumerator.MoveNext())
        yield return enumerator.Current;
}

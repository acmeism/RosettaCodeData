static string remove_vowels(string value)
{
    var stripped = from c in value.ToCharArray()
                   where !"aeiouAEIOU".Contains(c)
                   select c;

    return new string(stripped.ToArray());
}

static void test(string value)
{
    Console.WriteLine("Input:  " + value);
    Console.WriteLine("Output: " + remove_vowels(value));
}

static void Main(string[] args)
{
    test("CSharp Programming Language");
}

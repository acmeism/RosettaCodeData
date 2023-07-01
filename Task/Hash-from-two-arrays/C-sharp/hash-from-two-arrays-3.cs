using System.Linq;

static class Program
{
    static void Main()
    {
        string[] keys = { "foo", "bar", "val" };
        string[] values = { "little", "miss", "muffet" };

        var h = keys
            .Zip(values, (k, v) => (k, v))
            .ToDictionary(keySelector: kv => kv.k, elementSelector: kv => kv.v);
    }
}

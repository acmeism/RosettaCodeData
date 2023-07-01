static class Program
{
    static void Main()
    {
        System.Collections.Hashtable h = new System.Collections.Hashtable();

        string[] keys = { "foo", "bar", "val" };
        string[] values = { "little", "miss", "muffet" };

        System.Diagnostics.Trace.Assert(keys.Length == values.Length, "Arrays are not same length.");

        for (int i = 0; i < keys.Length; i++)
        {
            h.Add(keys[i], values[i]);
        }
    }
}

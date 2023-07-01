using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;

public static class Reflection
{
    public static void Main() {
        var t = new TestClass();
        var flags = BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance;
        foreach (var prop in GetPropertyValues(t, flags)) {
            Console.WriteLine(prop);
        }
        foreach (var field in GetFieldValues(t, flags)) {
            Console.WriteLine(field);
        }
    }

    public static IEnumerable<(string name, object value)> GetPropertyValues<T>(T obj, BindingFlags flags) =>
        from p in typeof(T).GetProperties(flags)
        where p.GetIndexParameters().Length == 0 //To filter out indexers
        select (p.Name, p.GetValue(obj, null));

    public static IEnumerable<(string name, object value)> GetFieldValues<T>(T obj, BindingFlags flags) =>
        typeof(T).GetFields(flags).Select(f => (f.Name, f.GetValue(obj)));

    class TestClass
    {
        private int privateField = 7;
        public int PublicNumber { get; } = 4;
        private int PrivateNumber { get; } = 2;
    }

}

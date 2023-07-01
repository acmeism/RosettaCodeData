using System;
using System.Reflection;

public class Rosetta
{
    public static void Main()
    {
        //Let's get all methods, not just public ones.
        BindingFlags flags = BindingFlags.Instance | BindingFlags.Static
            | BindingFlags.Public | BindingFlags.NonPublic
            | BindingFlags.DeclaredOnly;

        foreach (var method in typeof(TestForMethodReflection).GetMethods(flags))
            Console.WriteLine(method);
    }

    class TestForMethodReflection
    {
        public void MyPublicMethod() {}
        private void MyPrivateMethod() {}

        public static void MyPublicStaticMethod() {}
        private static void MyPrivateStaticMethod() {}
    }

}

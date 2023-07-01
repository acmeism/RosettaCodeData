using System;
using System.Collections.Generic;

static class Program
{
    // In short:
    public static void Foo()
    {
        string s;

        // Assign empty string:
        s = "";
        // or
        s = string.Empty;

        // Check for empty string only (false if s is null):
        if (s != null && s.Length == 0) { }

        // Check for null or empty (more idiomatic in .NET):
        if (string.IsNullOrEmpty(s)) { }
    }

    public static void Main()
    {
        // Equality is somewhat convoluted in .NET.
        // The methods above are the author's recommendation for each case.

        // s is initialized to null. It is a variable of the System.String type that is a null reference and is not
        // the empty string.
        string s = null;

        // Alias Console.WriteLine(bool) with a shorter name to make the demonstration code less verbose.
        Action<bool> P = Console.WriteLine;

        // Assign the empty string literal to s.
        s = "";

        // ' Assign String.Empty to s.
        s = string.Empty;

        // The empty string literal is the same object reference as String.Empty because of string interning, meaning the
        // behavior of the two is identical.
        // From this point on, "" will be used instead of String.Empty for brevity.

        //#== operator (object)
        // The == operator tests for reference equality when overload resolution fails to find an operator defined by
        // either operand type. However, which strings are interned is a CLR implementation detail and may be unreliable
        // when comparing non-empty strings. The equivalent in VB.NET would be s Is "".
        // Note that there is no such operator as Object.op_Equality(Object, Object): the use of the == operator for
        // types of type Object is a C# language feature.
        P((object)s == "");

        //#Object.ReferenceEquals(Object, Object)
        // The previous line is semantically to the following, though it does not involve a method call.
        P(object.ReferenceEquals(s, ""));

        //#String.op_Equality(String, String)
        // The equality operator of System.String is implemented as a call to String.Equals(String). Operators cannot be
        // called with method syntax in C#.
        P(s == "");

        //#String.Equals(String, String)
        // Call the static method defined on the String type, which first calls Object.ReferenceEquals and then, after
        // verifying that both are strings of the same length, compares the strings character-by-character.
        P(string.Equals(s, ""));

        //#Object.Equals(Object, Object)
        // First checks for reference equality and whether one or both of the arguments is null. It then invokes the
        // instance Equals method of the left parameter.
        P(object.Equals(s, ""));

        //#String.Equals(String)
        // The method is called with the string literal as the receiver because a NullReferenceException is thrown if s
        // is null.
        P("".Equals(s));

        //#String.Length
        // Check the Length property. The ?. (null-conditional) operator is used to avoid NullReferenceException. The Equals
        // call above can also be done this way. Null propagation makes the equality operator return false if one operand
        // is a Nullable<T> and does not have a value, making this result in false when s is null.
        P(s?.Length == 0);

        //#String.Length
        // A more traditional version of the null-conditional using a guard clause.
        // Both the null-conditional and this are noticeably (~4 times) faster than "".Equals(s). In general, it appears that
        // for empty strings, using the length is faster than using an equality comparison.
        P(s != null && s.Length == 0);

        //#String.IsNullOrEmpty(String)
        // Note that all of the other methods give false for null.
        // A static method of System.String that returns true if the string is null or its length is zero.
        P(string.IsNullOrEmpty(s));

        //#System.Collections.Generic.EqualityComparer(Of String).Default.Equals(String, String)
        // The EqualityComparer(Of T) class provides default implementations when an IEqualityComparer(Of T) is required.
        // The implementation for String calls String.Equals(String).
        P(EqualityComparer<string>.Default.Equals(s, ""));

        Console.WriteLine();

        // Each of the means described above, except testing for a non-empty string.
        P((object)s != "");
        P(!object.ReferenceEquals(s, ""));
        P(s != "");
        P(!string.Equals(s, ""));
        P(!object.Equals(s, ""));
        P(!"".Equals(s));
        P(s?.Length != 0); // Still false when s is null!
        P(s == null || s.Length != 0);
        P(!string.IsNullOrEmpty(s));
        P(!EqualityComparer<string>.Default.Equals(s, ""));
    }
}

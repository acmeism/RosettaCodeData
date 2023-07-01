Option Strict On

Module Program
    Sub Main()
        ' Equality is somewhat convoluted in .NET, and VB doesn't help by adding legacy means of comparison.
        ' The methods above are the author's recommendation for each case.
        ' Some also return true if the string is Nothing/null; this is noted in the description for those that
        ' do.

        ' s is initialized to Nothing. It is a variable of the System.String type that is a null reference and is not
        ' the empty string.
        Dim s As String = Nothing

        ' Alias Console.WriteLine(Boolean) with a shorter name to make the demonstration code less verbose.
        Dim P As Action(Of Boolean) = AddressOf Console.WriteLine

        ' Assign the empty string literal to s.
        s = ""

        '' Assign String.Empty to s.
        s = String.Empty

        ' The empty string literal is the same object reference as String.Empty because of string interning, meaning the
        ' behavior of the two is identical.
        ' From this point on, "" will be used instead of String.Empty for brevity.

        '#Is operator
        ' The Is operator tests for reference equality. However, which strings are interned is a CLR implementation
        ' detail and may be unreliable when comparing non-empty strings. The equivalent in C# would be (object)s == "".
        ' Note that there is no such operator as Object.op_Equality(Object, Object): the use of the == operator for
        ' types of type Object is a C# language feature.
        P(s Is "")

        '#Object.ReferenceEquals(Object, Object)
        ' The previous line is semantically to the following, though it does not involve a method call.
        P(Object.ReferenceEquals(s, ""))

        '#= Operator
        'True for Nothing.
        ' The VB.NET compiler does not use the System.String implementation of the equality operator. Instead, it emits
        ' a call to a method in the Visual Basic runtime, Operators.CompareString, which checks for reference equality
        ' before calling System.String.CompareOrdinal(String, String), which checks again for reference equality before
        ' comparing character-by-character.
        P(s = "")

        '#Microsoft.VisualBasic.CompilerServices.Operators.CompareString(String, String, Boolean)
        'True for Nothing.
        ' Equivalent to the above line, though methods in the CompilerServices namespace are not meant for use by
        ' regular code.
        ' The third argument indicates whether to use a textual comparison (e.g. ignore case and diacritics).
        P(0 = CompilerServices.Operators.CompareString(s, "", False))

        '#Microsoft.VisualBasic.Strings.StrComp(String, String, [CompareMethod])
        'True for Nothing.
        ' A wrapper around CompareString that is intended for use.
        P(0 = StrComp(s, ""))

        '#String.op_Equality(String, String)
        ' It is possible to directly call the equality operator of System.String, which is implemented as a call to
        ' String.Equals(String).
        P(String.op_Equality(s, ""))

        '#String.Equals(String, String)
        ' Call the static method defined on the String type.
        '  first calls Object.ReferenceEquals and then, after verifying that both are strings of the same length,
        ' compares the strings character-by-character.
        P(String.Equals(s, ""))

        '#Object.Equals(Object, Object)
        ' First checks for reference equality and whether one or both of the arguments is Nothing. It then invokes the
        ' instance Equals method of the left parameter.
        P(Object.Equals(s, ""))

        '#String.Equals(String)
        ' The method is called with the string literal as the receiver because a NullReferenceException is thrown if s
        ' is Nothing.
        P("".Equals(s))

        '#Microsoft.VisualBasic.Strings.Len(String)
        'True for Nothing.
        ' Check the length using Microsoft.VisualBasic.Strings.Len(String). This method returns s?.Length (see below).
        P(0 = Len(s))

        '#String.Length
        ' Check the Length property. The ?. (null-conditional) operator is used to avoid NullReferenceException. The Equals
        ' call above can also be done this way.
        ' A method call must be added because the equality operator propagates Nothing/null (that is, the result of the
        ' expression is Nullable(Of Boolean)). This has the side effect of making it behave "correctly" for null.
        P((s?.Length = 0).GetValueOrDefault())

        ' The If statement automatically unwraps nullable Booleans, however.
        If s?.Length = 0 Then
        End If

        '#String.Length
        ' A more traditional version of the null-conditional using a guard clause.
        ' Both the null-conditional and this are noticeably (~4 times) faster than "".Equals(s). In general, it appears that
        ' for empty strings, using the length is faster than using an equality comparison.
        P(s IsNot Nothing AndAlso s.Length = 0)

        '#String.IsNullOrEmpty(String)
        'True for Nothing
        ' A static method of System.String that returns true if the string is Nothing or its length is zero.
        P(String.IsNullOrEmpty(s))

        '#System.Collections.Generic.EqualityComparer(Of String).Default.Equals(String, String)
        ' The EqualityComparer(Of T) class provides default implementations when an IEqualityComparer(Of T) is required.
        ' The implementation for String calls String.Equals(String).
        P(EqualityComparer(Of String).Default.Equals(s, ""))

        Console.WriteLine()

        ' Each of the methods described above, except testing for a non-empty string.
        P(s IsNot "")
        P(Not Object.ReferenceEquals(s, ""))
        P(s <> "")
        P(0 <> CompilerServices.Operators.CompareString(s, "", False))
        P(0 <> StrComp(s, ""))
        P(String.op_Inequality(s, ""))
        P(Not String.Equals(s, ""))
        P(Not Object.Equals(s, ""))
        P(Not "".Equals(s))
        P(Len(s) <> 0)
        P((s?.Length <> 0).GetValueOrDefault())
        P(s Is Nothing OrElse s.Length <> 0)
        P(Not String.IsNullOrEmpty(s))
        P(Not EqualityComparer(Of String).Default.Equals(s, ""))
    End Sub
End Module

let palindrome (s : string) =
    let a = s.ToUpper().ToCharArray()
    Array.rev a = a


open NUnit.Framework

[<TestFixture>]
type TestCases() =
    [<Test>]
    member x.Test01() =
        Assert.IsTrue(palindrome "radar")

    [<Test>]
    member x.Test02() =
        Assert.IsFalse(palindrome "hello")

open System
open System.Text.RegularExpressions

let balancedComments opening closing =
    new Regex(
        String.Format("""
{0}                       # An outer opening delimiter
    (?>                   # efficiency: no backtracking here
        {0} (?<LEVEL>)    # An opening delimiter, one level down
        |
        {1} (?<-LEVEL>)   # A closing delimiter, one level up
        |
        (?! {0} | {1} ) . # With negative lookahead: Anything but delimiters
    )*                    # As many times as we see these
    (?(LEVEL)(?!))        # Fail, unless on level 0 here
{1}                       # Outer closing delimiter
""", Regex.Escape(opening), Regex.Escape(closing)),
        RegexOptions.IgnorePatternWhitespace ||| RegexOptions.Singleline)

[<EntryPoint>]
let main args =
    let sample = """
    /**
    * Some comments
    * longer comments here that we can parse.
    *
    * Rahoo
    */
    function subroutine() {
    a = /* inline comment */ b + c ;
    }
    /*/ <-- tricky comments */

    /**
    * Another comment.
    * /* nested balanced
    */ */
    function something() {
    }
    """
    let balancedC = balancedComments "/*" "*/"
    printfn "%s" (balancedC.Replace(sample, ""))
    0

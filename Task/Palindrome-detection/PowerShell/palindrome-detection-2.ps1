function Test-Palindrome
{
  <#
    .SYNOPSIS
        Tests if a string is a palindrome.
    .DESCRIPTION
        Tests if a string is a true palindrome or, optionally, an inexact palindrome.
    .EXAMPLE
        Test-Palindrome -Text "racecar"
    .EXAMPLE
        Test-Palindrome -Text '"Deliver desserts," demanded Nemesis, "emended, named, stressed, reviled."' -Inexact
  #>
    [CmdletBinding()]
    [OutputType([bool])]
    Param
    (
        # The string to test for palindrominity.
        [Parameter(Mandatory=$true)]
        [string]
        $Text,

        # When specified, detects an inexact palindrome.
        [switch]
        $Inexact
    )

    if ($Inexact)
    {
        # Strip all punctuation and spaces
        $Text = [Regex]::Replace("$Text($7&","[^1-9a-zA-Z]","")
    }

    $Text -match "^(?'char'[a-z])+[a-z]?(?:\k'char'(?'-char'))+(?(char)(?!))$"
}

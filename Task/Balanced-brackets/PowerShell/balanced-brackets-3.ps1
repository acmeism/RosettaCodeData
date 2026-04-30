function Test-BalancedBracket
{
  <#
    .SYNOPSIS
        Tests a string for balanced brackets.
    .DESCRIPTION
        Tests a string for balanced brackets. ("<>", "[]", "{}" or "()")
    .EXAMPLE
        Test-BalancedBracket -Bracket Brace -String '{abc(def[0]).xyz}'
        Test a string for balanced braces.
    .EXAMPLE
        Test-BalancedBracket -Bracket Curly -String '{abc(def[0]).xyz}'
        Test a string for balanced curly braces.
    .EXAMPLE
        Test-BalancedBracket -Bracket Curly -String ([System.IO.File]::ReadAllText('.\Foo.ps1'))
        Test a file for balanced curly braces.
    .LINK
        http://go.microsoft.com/fwlink/?LinkId=133231
  #>
    [CmdletBinding()]
    [OutputType([bool])]
    Param
    (
        [Parameter(Mandatory=$true)]
        [ValidateSet("Angle", "Brace", "Curly", "Paren")]
        [string]
        $Bracket,

        [Parameter(Mandatory=$true)]
        [AllowEmptyString()]
        [string]
        $String
    )

    $notFound = -1

    $brackets = @{
        Angle = @{Left="<"; Right=">"; Regex="^[^<>]*(?>(?>(?'pair'\<)[^<>]*)+(?>(?'-pair'\>)[^<>]*)+)+(?(pair)(?!))$"}
        Brace = @{Left="["; Right="]"; Regex="^[^\[\]]*(?>(?>(?'pair'\[)[^\[\]]*)+(?>(?'-pair'\])[^\[\]]*)+)+(?(pair)(?!))$"}
        Curly = @{Left="{"; Right="}"; Regex="^[^{}]*(?>(?>(?'pair'\{)[^{}]*)+(?>(?'-pair'\})[^{}]*)+)+(?(pair)(?!))$"}
        Paren = @{Left="("; Right=")"; Regex="^[^()]*(?>(?>(?'pair'\()[^()]*)+(?>(?'-pair'\))[^()]*)+)+(?(pair)(?!))$"}
    }

    if ($String.IndexOf($brackets.$Bracket.Left)  -eq $notFound -and
        $String.IndexOf($brackets.$Bracket.Right) -eq $notFound -or  $String -eq [String]::Empty)
    {
        return $true
    }

    $String -match $brackets.$Bracket.Regex
}


'', '[]', '][', '[][]', '][][', '[[][]]', '[]][[]' | ForEach-Object {
    if ($_ -eq "") { $s = "(Empty)" } else { $s = $_ }
    "{0}: {1}" -f  $s.PadRight(8), "$(if (Test-BalancedBracket Brace $s) {'Is balanced.'} else {'Is not balanced.'})"
}

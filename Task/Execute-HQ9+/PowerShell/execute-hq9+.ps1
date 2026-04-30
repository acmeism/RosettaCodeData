function Invoke-HQ9PlusInterpreter ([switch]$Global)
{
    $sb = New-Object -TypeName System.Text.StringBuilder

    for ($i = 99; $i -gt 2; $i--)
    {
        $sb.Append((("{0,2} bottles of beer on the wall, " +
                     "{0,2} bottles of beer! Take one down, pass it around, " +
                     "{1,2} bottles of beer on the wall.`n") -f $i, ($i - 1))) | Out-Null
    }
    $sb.Append((" 2 bottles of beer on the wall, " +
                " 2 bottles of beer! Take one down, pass it around, " +
                " 1 bottle  of beer on the wall.`n")) | Out-Null
    $sb.Append((" 1 bottle  of beer on the wall, " +
                " 1 bottle  of beer! Take one down, pass it around...`n")) | Out-Null
    $sb.Append(("No more bottles of beer on the wall, No more bottles of beer!`n" +
                "Go to the store and get us some more, 99 bottles of beer on the wall!")) | Out-Null

    $99BottlesOfBeer = $sb.ToString()

    $helloWorld = "Hello, world!"

    if ($Global) {New-Variable -Name "+" -Value 0 -Scope Global -ErrorAction SilentlyContinue}

    Write-Host "Press Ctrl-C or Enter nothing to exit." -ForegroundColor Cyan

    while ($code -ne "")
    {
        $code = Read-Host -Prompt "HQ9+"

        ($code.ToCharArray() | Select-String -Pattern "[HQ9+]").Matches.Value | ForEach-Object {
            switch ($_)
            {
                "H" {$helloWorld;           break}
                "Q" {$code;                 break}
                "9" {$99BottlesOfBeer;      break}
                "+" {if ($Global) {${global:+}++}}
            }
        }
    }
}

Set-Alias -Name HQ9+ -Value Invoke-HQ9PlusInterpreter

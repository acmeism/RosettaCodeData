# Author: M. McNabb
function Get-CaesarCipher
{
Param
(
[Parameter(
Mandatory=$true,ValueFromPipeline=$true)]
[string]
$Text,

[ValidateRange(1,25)]
[int]
$Key = 1,

[switch]
$Decode
)

begin
{
    $LowerAlpha = [char]'a'..[char]'z'
    $UpperAlpha = [char]'A'..[char]'Z'
}

process
{
    $Chars = $Text.ToCharArray()

    function encode
    {
        param
        (
        $Char,
        $Alpha = [char]'a'..[char]'z'
        )
        $Index = $Alpha.IndexOf([int]$Char)
        $NewIndex = ($Index + $Key) - $Alpha.Length
        $Alpha[$NewIndex]
    }

    function decode
    {
        param
        (
        $Char,
        $Alpha = [char]'a'..[char]'z'
        )
        $Index = $Alpha.IndexOf([int]$Char)
        $int = $Index - $Key
        if ($int -lt 0) {$NewIndex = $int + $Alpha.Length}
        else {$NewIndex = $int}
        $Alpha[$NewIndex]
    }

    foreach ($Char in $Chars)
    {
        if ([int]$Char -in $LowerAlpha)
        {
            if ($Decode) {$Char = decode $Char}
            else {$Char = encode $Char}
        }
        elseif ([int]$Char -in $UpperAlpha)
        {
            if ($Decode) {$Char = decode $Char $UpperAlpha}
            else {$Char = encode $Char $UpperAlpha}
        }

        $Char = [char]$Char
        [string]$OutText += $Char
    }

    $OutText
    $OutText = $null
}
}

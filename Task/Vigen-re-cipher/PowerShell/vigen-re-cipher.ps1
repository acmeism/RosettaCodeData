# Author: D. Cudnohufsky
function Get-VigenereCipher
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [string] $Text,

        [Parameter(Mandatory=$true)]
        [string] $Key,

        [switch] $Decode
    )

    begin
    {
        $map = [char]'A'..[char]'Z'
    }

    process
    {
        $Key = $Key -replace '[^a-zA-Z]',''
        $Text = $Text -replace '[^a-zA-Z]',''

        $keyChars = $Key.toUpper().ToCharArray()
        $Chars = $Text.toUpper().ToCharArray()

        function encode
        {

            param
            (
                $Char,
                $keyChar,
                $Alpha = [char]'A'..[char]'Z'
            )

            $charIndex = $Alpha.IndexOf([int]$Char)
            $keyIndex = $Alpha.IndexOf([int]$keyChar)
            $NewIndex = ($charIndex + $KeyIndex) - $Alpha.Length
            $Alpha[$NewIndex]

        }

        function decode
        {

            param
            (
                $Char,
                $keyChar,
                $Alpha = [char]'A'..[char]'Z'
            )

            $charIndex = $Alpha.IndexOf([int]$Char)
            $keyIndex = $Alpha.IndexOf([int]$keyChar)
            $int = $charIndex - $keyIndex
            if ($int -lt 0) { $NewIndex = $int + $Alpha.Length }
            else { $NewIndex = $int }
            $Alpha[$NewIndex]
        }

        while ( $keyChars.Length -lt $Chars.Length )
        {
            $keyChars = $keyChars + $keyChars
        }

        for ( $i = 0; $i -lt $Chars.Length; $i++ )
        {

            if ( [int]$Chars[$i] -in $map -and [int]$keyChars[$i] -in $map )
            {
                if ($Decode) {$Chars[$i] = decode $Chars[$i] $keyChars[$i] $map}
                else {$Chars[$i] = encode $Chars[$i] $keyChars[$i] $map}

                $Chars[$i] = [char]$Chars[$i]
                [string]$OutText += $Chars[$i]
            }

        }

        $OutText
        $OutText = $null
    }
}

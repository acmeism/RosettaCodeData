#  Test
$Strings = @( "" )
$Strings += 1..5 | ForEach { ( [char[]]("[]" * $_) | Get-Random -Count ( $_ * 2 ) ) -join "" }

ForEach ( $String in $Strings )
    {
    $String.PadRight( 12, " " ) + (Get-BalanceStatus $String)
    }

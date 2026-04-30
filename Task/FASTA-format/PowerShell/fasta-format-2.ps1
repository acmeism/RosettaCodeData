$file = @'
>Rosetta_Example_1
THERECANBENOSPACE
>Rosetta_Example_2
THERECANBESEVERAL
LINESBUTTHEYALLMUST
BECONCATENATED
'@

$lines = $file.Replace("`n","~").Split(">") | ForEach-Object {$_.TrimEnd("~").Split("`n",2,[StringSplitOptions]::RemoveEmptyEntries)}

$output = New-Object -TypeName PSObject

foreach ($line in $lines)
{
    $name, $value = $line.Split("~",2) | ForEach-Object {$_.Replace("~","")}

    $output | Add-Member -MemberType NoteProperty -Name $name -Value $value
}

$output | Format-List

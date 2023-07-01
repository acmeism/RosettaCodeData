$method = ([Math] | Get-Member -MemberType Method -Static | Where-Object {$_.Definition.Split(',').Count -eq 1} | Get-Random).Name
$number = (1..9 | Get-Random) / 10
$result = [Math]::$method($number)
$output = [PSCustomObject]@{
    Method = $method
    Number = $number
    Result = $result
}

$output | Format-List

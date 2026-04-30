$string = "a!===b=!=c"
$separators = [regex]"(==|!=|=)"

$matchInfo = $separators.Matches($string) |
    Select-Object -Property Index, Value |
    Group-Object  -Property Value |
    Select-Object -Property @{Name="Separator"; Expression={$_.Name}},
                            Count,
                            @{Name="Position" ; Expression={$_.Group.Index}}

$matchInfo

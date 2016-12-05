function Action ([scriptblock]$Expression, [Alias("if")][bool]$Test)
{
    if ($Test) {&$Expression}
}

Set-Alias -Name say -Value Action

say {"Thank God it's Friday!"} -if (Get-Date 5/27/2016).DayOfWeek -eq "Friday"

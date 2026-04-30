11,2020,21200,321100 | ForEach-Object {
    [PSCustomObject]@{
        Number = $_
        IsSelfDescribing = Test-SelfDescribing -Number $_
    }
} | Format-Table -AutoSize

function Get-MeanAngle ([double[]]$Angles)
{
    $x = ($Angles | ForEach-Object {[Math]::Cos($_ * [Math]::PI / 180)} | Measure-Object -Average).Average
    $y = ($Angles | ForEach-Object {[Math]::Sin($_ * [Math]::PI / 180)} | Measure-Object -Average).Average

    [Math]::Atan2($y, $x) * 180 / [Math]::PI
}

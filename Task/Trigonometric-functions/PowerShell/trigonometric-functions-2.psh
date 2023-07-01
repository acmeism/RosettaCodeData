$radians = [Math]::PI / 4
$degrees = 45

[PSCustomObject]@{Radians=[Math]::Sin($radians); Degrees=[Math]::Sin($degrees * [Math]::PI / 180)}
[PSCustomObject]@{Radians=[Math]::Cos($radians); Degrees=[Math]::Cos($degrees * [Math]::PI / 180)}
[PSCustomObject]@{Radians=[Math]::Tan($radians); Degrees=[Math]::Tan($degrees * [Math]::PI / 180)}

[double]$tempVar = [Math]::Asin([Math]::Sin($radians))
[PSCustomObject]@{Radians=$tempVar; Degrees=$tempVar * 180 / [Math]::PI}

[double]$tempVar = [Math]::Acos([Math]::Cos($radians))
[PSCustomObject]@{Radians=$tempVar; Degrees=$tempVar * 180 / [Math]::PI}

[double]$tempVar = [Math]::Atan([Math]::Tan($radians))
[PSCustomObject]@{Radians=$tempVar; Degrees=$tempVar * 180 / [Math]::PI}

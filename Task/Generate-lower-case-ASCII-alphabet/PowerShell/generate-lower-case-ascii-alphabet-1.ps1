$asString = 97..122 | ForEach-Object -Begin {$asArray = @()} -Process {$asArray += [char]$_} -End {$asArray -join('')}
$asString

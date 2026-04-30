$title = "Dong Work For Yuda"
$scriptblock = {$title}
$closedScriptblock = $scriptblock.GetNewClosure()

& $scriptblock
& $closedScriptblock

$Strings = "Enjoy","Rosetta","Code"

$SB = {param($String)Write-Output $String}

$Pool = [RunspaceFactory]::CreateRunspacePool(1, 3)
$Pool.ApartmentState = "STA"
$Pool.Open()
foreach ($String in $Strings) {
    $Pipeline  = [System.Management.Automation.PowerShell]::create()
    $Pipeline.RunspacePool = $Pool
    [void]$Pipeline.AddScript($SB).AddArgument($String)
    $AsyncHandle = $Pipeline.BeginInvoke()
    $Pipeline.EndInvoke($AsyncHandle)
    $Pipeline.Dispose()
    }
$Pool.Close()

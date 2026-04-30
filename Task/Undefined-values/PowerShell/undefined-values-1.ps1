if (Get-Variable -Name noSuchVariable -ErrorAction SilentlyContinue)
{
    $true
}
else
{
    $false
}

function Get-Accumulator ([double]$Start)
{
    {param([double]$Plus) return $script:Start += $Plus}.GetNewClosure()
}

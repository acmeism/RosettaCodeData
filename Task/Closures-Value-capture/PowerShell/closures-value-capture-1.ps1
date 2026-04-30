function Get-Closure ([double]$Number)
{
    {param([double]$Sum) return $script:Number *= $Sum}.GetNewClosure()
}

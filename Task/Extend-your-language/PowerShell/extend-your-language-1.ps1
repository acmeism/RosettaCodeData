function When-Condition
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [bool]
        $Test1,

        [Parameter(Mandatory=$true, Position=1)]
        [bool]
        $Test2,

        [Parameter(Mandatory=$true, Position=2)]
        [scriptblock]
        $Both,

        [Parameter(Mandatory=$true, Position=3)]
        [scriptblock]
        $First,

        [Parameter(Mandatory=$true, Position=4)]
        [scriptblock]
        $Second,

        [Parameter(Mandatory=$true, Position=5)]
        [scriptblock]
        $Neither
    )

    if ($Test1 -and $Test2)
    {
        return (&$Both)
    }
    elseif ($Test1 -and -not $Test2)
    {
        return (&$First)
    }
    elseif (-not $Test1 -and $Test2)
    {
        return (&$Second)
    }
    else
    {
        return (&$Neither)
    }
}

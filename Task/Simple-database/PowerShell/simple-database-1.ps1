function db
{
    [CmdletBinding(DefaultParameterSetName="None")]
    [OutputType([PSCustomObject])]
    Param
    (
        [Parameter(Mandatory=$false,
                   Position=0,
                   ParameterSetName="Add a new entry")]
        [string]
        $Path = ".\SimpleDatabase.csv",

        [Parameter(Mandatory=$true,
                   ParameterSetName="Add a new entry")]
        [string]
        $Name,

        [Parameter(Mandatory=$true,
                   ParameterSetName="Add a new entry")]
        [string]
        $Category,

        [Parameter(Mandatory=$true,
                   ParameterSetName="Add a new entry")]
        [datetime]
        $Birthday,

        [Parameter(ParameterSetName="Print the latest entry")]
        [switch]
        $Latest,

        [Parameter(ParameterSetName="Print the latest entry for each category")]
        [switch]
        $LatestByCategory,

        [Parameter(ParameterSetName="Print all entries sorted by a date")]
        [switch]
        $SortedByDate
    )

    if (-not (Test-Path -Path $Path))
    {
        '"Name","Category","Birthday"' | Out-File -FilePath $Path
    }

    $db = Import-Csv -Path $Path | Foreach-Object {
        $_.Birthday = $_.Birthday -as [datetime]
        $_
    }

    switch ($PSCmdlet.ParameterSetName)
    {
        "Add a new entry"
        {
            [PSCustomObject]@{Name=$Name; Category=$Category; Birthday=$Birthday} | Export-Csv -Path $Path -Append
        }
        "Print the latest entry"
        {
            $db[-1]
        }
        "Print the latest entry for each category"
        {
            ($db | Group-Object -Property Category).Name | ForEach-Object {($db | Where-Object -Property Category -Contains $_)[-1]}
        }
        "Print all entries sorted by a date"
        {
            $db | Sort-Object -Property Birthday
        }
        Default
        {
            $db
        }
    }
}

db -Name Bev   -Category friend   -Birthday 3/3/1983
db -Name Bob   -Category family   -Birthday 7/19/1987
db -Name Gill  -Category friend   -Birthday 12/9/1986
db -Name Gail  -Category family   -Birthday 2/11/1986
db -Name Vince -Category family   -Birthday 3/10/1960
db -Name Wayne -Category coworker -Birthday 5/29/1962

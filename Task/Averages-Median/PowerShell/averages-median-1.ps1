function Measure-Data
{
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param
    (
        [Parameter(Mandatory=$true,
                   Position=0)]
        [double[]]
        $Data
    )

    Begin
    {
        function Get-Mode ([double[]]$Data)
        {
            if ($Data.Count -gt ($Data | Select-Object -Unique).Count)
            {
                $groups = $Data | Group-Object | Sort-Object -Property Count -Descending

                return ($groups | Where-Object {[double]$_.Count -eq [double]$groups[0].Count}).Name | ForEach-Object {[double]$_}
            }
            else
            {
                return $null
            }
        }

        function Get-StandardDeviation ([double[]]$Data)
        {
            $variance = 0
            $average  = $Data | Measure-Object -Average | Select-Object -Property Count, Average

            foreach ($number in $Data)
            {
                $variance +=  [Math]::Pow(($number - $average.Average),2)
            }

            return [Math]::Sqrt($variance / ($average.Count-1))
        }

        function Get-Median ([double[]]$Data)
        {
            if ($Data.Count % 2)
            {
                return $Data[[Math]::Floor($Data.Count/2)]
            }
            else
            {
                return ($Data[$Data.Count/2], $Data[$Data.Count/2-1] | Measure-Object -Average).Average
            }
        }
    }
    Process
    {
        $Data = $Data | Sort-Object

        $Data | Measure-Object -Maximum -Minimum -Sum -Average |
                Select-Object -Property Count,
                                        Sum,
                                        Minimum,
                                        Maximum,
                                        @{Name='Range'; Expression={$_.Maximum - $_.Minimum}},
                                        @{Name='Mean' ; Expression={$_.Average}} |
                Add-Member -MemberType NoteProperty -Name Median            -Value (Get-Median $Data)            -PassThru |
                Add-Member -MemberType NoteProperty -Name StandardDeviation -Value (Get-StandardDeviation $Data) -PassThru |
                Add-Member -MemberType NoteProperty -Name Mode              -Value (Get-Mode $Data)              -PassThru
    }
}

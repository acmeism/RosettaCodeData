function Get-Ranking
{
    [CmdletBinding(DefaultParameterSetName="Standard")]
    [OutputType([PSCustomObject])]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string]
        $InputObject,

        [Parameter(Mandatory=$false,
                   ParameterSetName="Standard")]
        [switch]
        $Standard,

        [Parameter(Mandatory=$false,
                   ParameterSetName="Modified")]
        [switch]
        $Modified,

        [Parameter(Mandatory=$false,
                   ParameterSetName="Dense")]
        [switch]
        $Dense,

        [Parameter(Mandatory=$false,
                   ParameterSetName="Ordinal")]
        [switch]
        $Ordinal,

        [Parameter(Mandatory=$false,
                   ParameterSetName="Fractional")]
        [switch]
        $Fractional
    )

    Begin
    {
        function Get-OrdinalRank ([PSCustomObject[]]$Values)
        {
            for ($i = 0; $i -lt $Values.Count; $i++)
            {
                $Values[$i].Rank = $i + 1
            }

            $Values
        }

        function Get-Rank ([PSCustomObject[]]$Scores)
        {
            foreach ($score in $Scores)
            {
                $score.Group | ForEach-Object {$_.Rank = $score.Rank}
            }

            $Scores.Group
        }

        function New-Competitor ([string]$Name, [int]$Score, [int]$Rank = 0)
        {
            [PSCustomObject]@{
                Name  = $Name
                Score = $Score
                Rank  = $Rank
            }
        }

        $competitors = @()
        $scores = @()
    }
    Process
    {
        @($input) | ForEach-Object {$competitors += New-Competitor -Name $_.Split()[1] -Score $_.Split()[0]}
    }
    End
    {
        $scores = $competitors |
            Sort-Object   -Property Score -Descending |
            Group-Object  -Property Score |
            Select-Object -Property @{Name="Score"; Expression={[int]$_.Name}}, @{Name="Rank"; Expression={0}}, Count, Group

        switch ($PSCmdlet.ParameterSetName)
        {
            "Standard"
            {
                $rank = 1

                for ($i = 0; $i -lt $scores.Count; $i++)
                {
                    $scores[$i].Rank = $rank
                    $rank += $scores[$i].Count
                }

                Get-Rank $scores
            }
            "Modified"
            {
                $rank = 0

                foreach ($score in $scores)
                {
                    $rank = $score.Count + $rank
                    $score.Rank = $rank
                }

                Get-Rank $scores
            }
            "Dense"
            {
                for ($i = 0; $i -lt $scores.Count; $i++)
                {
                    $scores[$i].Rank = $i + 1
                }

                Get-Rank $scores
            }
            "Ordinal"
            {
                Get-OrdinalRank $competitors
            }
            "Fractional"
            {
                Get-OrdinalRank $competitors | Group-Object -Property Score | ForEach-Object {
                    if ($_.Count -gt 1)
                    {
                        $rank = ($_.Group.Rank | Measure-Object -Average).Average

                        foreach ($competitor in $_.Group)
                        {
                            $competitor.Rank = $rank
                        }
                    }
                }

                $competitors
            }
        }
    }
}

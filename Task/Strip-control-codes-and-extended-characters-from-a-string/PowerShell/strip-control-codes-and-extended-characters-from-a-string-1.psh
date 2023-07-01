function Remove-Character
{
    [CmdletBinding(DefaultParameterSetName="Control and Extended")]
    [OutputType([string])]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string]
        $String,

        [Parameter(ParameterSetName="Control")]
        [switch]
        $Control,

        [Parameter(ParameterSetName="Extended")]
        [switch]
        $Extended
    )

    Begin
    {
        filter Remove-ControlCharacter
        {
            $_.ToCharArray() | ForEach-Object -Begin {$out = ""} -Process {if (-not [Char]::IsControl($_)) {$out += $_ }} -End {$out}
        }

        filter Remove-ExtendedCharacter
        {
            $_.ToCharArray() | ForEach-Object -Begin {$out = ""} -Process {if ([int]$_ -lt 127) {$out += $_ }} -End {$out}
        }
    }
    Process
    {
        foreach ($s in $String)
        {
            switch ($PSCmdlet.ParameterSetName)
            {
                "Control"  {$s | Remove-ControlCharacter}
                "Extended" {$s | Remove-ExtendedCharacter}
                Default    {$s | Remove-ExtendedCharacter | Remove-ControlCharacter}
            }
        }
    }
}
